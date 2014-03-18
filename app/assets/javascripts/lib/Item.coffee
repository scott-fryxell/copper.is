jQuery.ajaxPrefilter (options, originalOptions, xhr) ->
  unless options.crossDomain
    if token = $('meta[name="csrf-token"]').attr('content')
      xhr.setRequestHeader('X-CSRF-Token', token)

jQuery.update_view(item) ->
  $('html').update_view(item)

jQuery.items(filter) ->
  $('html').items(filter)

jQuery.fn.extend

  items: ->
    document.items ?= {}

    # make sure that root dom is part of the find
    # should set by type. that way we can use the id
    $(@).find("[itemscope], [itemref]").each ->
      item = {}
      item.type = $(@).attr 'itemtype' if $(@).attr 'itemtype'

      unless item_id = $(@).attr 'itemid'
        item_id = $(@).attr 'itemref'

      document.items[item_id] = item

      $(@).find("[itemprop]").each ->
        parent = $(@).parents("[itemscope], [itemref]").first()

        unless check_id = $(parent).attr 'itemid'
          check_id = $(parent).attr 'itemref'

        item[$(@).attr 'itemprop'] = $(@).get_value() if item_id == check_id

        $(document.items[item_id]).extend(item)

    document.items = items
    return items

  get_value: ->
    if $(@).is 'input' or $(@).is 'textarea' or $(@).is 'select'
      if $(@).val()
        return $(@).val().trim()
      else
        return ''
    else if $(@).attr 'data-value'
      return $(@).attr 'data-value'
    else if $(@).is 'a' or $(@).is 'link'
      return $(@).attr 'href'
    else if $(@).is 'img' or $(@).is 'object' or $(@).is 'embed'
      return $(@).attr 'src'
    else if $(@).is 'meta'
      return $(@).attr 'content'
    else if $(@).is 'time'
      return $(@).attr 'datetime'
    else
      if $(@).text()
        val = $(@).text().trim()
        if val == 'true'
          return true
        if val is 'false'
          return false
        else
          return val

  update_view: (item) ->
    $.each item, (key, value) ->
      if value?
        $("[itemprop='#{key}']").each ->
          if $(@).is 'input' or $(@).is 'select' or $(@).is 'textarea'
            $(@).val value
          else if $(@).attr 'data-value'
            $(@).attr "data-value", value
          else if $(@).is 'a' or $(@).is 'link'
            $(@).attr 'href', value
          else if $(@).is 'img' or $(@).is 'object' or $(@).is 'embed'
            $(@).attr "src", value
          else
            $(@).text value
          $(@).trigger 'item.changed'

$(document).on 'item.update', 'data#items', ->
  new Items(@)
  $(@).find('[itemscope]').each ->
    item_id = $(@).attr('itemid')
    $(@).remove()
    $("[itemid='#{item_id}']")

$(document).on 'change', "[itemprop]", ->
  # console.debug($(@).parents("form"))
  unless $(@).parents("form").length > 0
    parent = $(@).parents("[itemscope], [itemref]").first()

    unless item_id = $(parent).attr 'itemid'
      item_id = $(parent).attr 'itemref'

    jQuery.ajax
      url: item_id
      headers: {retrieve_as_data: "true"}
      type: 'put'
      data: "#{$(@).attr('itemprop')}=#{$(@).get_value(@)}"
      success:  (data) ->
        # console.info "item.updated"
        $('data#items').append(jQuery.parseHTML(data))
        $('data#items').trigger('item.update')

      error: (data, textStatus, jqXHR) ->
        console.error "Error updating this item", data, textStatus, jqXHR

$(document).on 'click', 'details[itemscope]', ->
  # todo: instead of checking for elements i should just turn this event listener off
  unless $(@).find('section').length > 0 || $(@).find('details').length > 0
    # console.debug('getting info')
    jQuery.ajax
      url:$(@).attr('itemid'),
      headers: {retrieve_as_data: "true"}
      success: (data) =>
        $(@).append(data)
        # console.debug('element', @)
        new Items(@)
        $(@).find('time').timeago()

      statusCode:
        401:=>
          $(@).trigger "401"
          console.debug("you don't have rights to view this resource")

$(document).on 'submit', '[itemscope] form, [itemref] form', ->

  # capture form submissions for items. Determine
  # their values and submit the data via ajax.
  # this means forms are submited with CSRF protection
  # without requireing the forms themselves to know the token
  # The form is only submited if there are elements with
  # itemprop set

  event.preventDefault()

  # if their are no Items in the form just end the submit.
  # this assumes that some other actor is going to be taking
  # care of business

  if $(@).find("[itemprop]").length == 0 and 'delete' != $(@).attr('method')
    return true

  item_element = $(@).parents '[itemscope], [itemref]'

  unless id = $(item_element).attr 'itemid'
    id = $(item_element).attr 'itemref'

  item_index = 0;  # TODO get the index based on itemId
  type = $(item_element).attr 'itemtype'
  form = @
  action = $(@).attr 'action'

  unless action
    # determine the action from the itemscope
    action = id

  method = $(@).attr('method').toLowerCase()

  $(form).trigger 'item.validate'

  if $(form).find('.invalid').size() > 0
    return false;

  jQuery.ajax
    url: action
    type: method
    data: $(@).serialize()
    error: (data, textStatus, jqXHR) ->
      # let any listeners know that there was a problem with the form submit
      $(form).trigger 'item.error'
      $(item_element).update_view(item_element.items());
      console.error("error submiting item form #{id}", data, textStatus, jqXHR);

    success: (data, textStatus, jqXHR) ->
      # let any listeners know that any the form submited succesfully update.
      # TODO we leave updating the items to the listener of this method. this is risky
      $(form).trigger "item.#{method}", [data, textStatus, jqXHR]

  return false # don't submit the form let the ajax do the talking


