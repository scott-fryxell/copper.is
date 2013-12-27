$ = jQuery

$.fn.discover_items: (element) =>
  $(element).find("[itemscope], [itemref]").each ->
    item = {}

    item.type = $(@).attr 'itemtype' if $(@).attr 'itemtype'

    unless item_id = $(@).attr 'itemid'
      item_id = $(@).attr 'itemref'

    $(@).find("[itemprop]").each ->
      parent = $(@).parents("[itemscope], [itemref]").first()

      unless check_id = $(parent).attr 'itemid'
        check_id = $(parent).attr 'itemref'

      if item_id == check_id
        item_prop = $(@).attr 'itemprop'
        item[item_prop] = Item.get_value(@)

    $(document.items[item_id]).extend(item)
  return document.items
$.fn.get_value: (element) ->
  if $(element).is("input") or $(element).is("textarea") or $(element).is("select")
    if $(element).val()
      $(element).val().trim()
    else
      ""
  else if $(element).attr("data-value")
    $(element).attr "data-value"
  else if $(element).is("a") or $(element).is("link")
    $(element).attr "href"
  else if $(element).is("img") or $(element).is("object") or $(element).is("embed")
    $(element).attr "src"
  else if $(element).is("meta")
    $(element).attr "content"
  else if $(element).is("time")
    $(element).attr "datetime"
  else
    $(element).text().trim()  if $(element).text()
$.fn.update_page: (item) ->
  
  # update exsisting items on the page itemid
  # is assumed to be unique identifier
  $.each item, (key, value) ->
    if value?
      $("[itemprop=" + key + "]").each ->
        if $(this).is("input") or $(this).is("select") or $(this).is("textarea")
          $(this).val value
        else if $(this).attr("data-value")
          $(this).attr "data-value", value
        else if $(this).is("a") or $(this).is("link")
          $(this).attr "href", value
        else if $(this).is("img") or $(this).is("object") or $(this).is("embed")
          $(this).attr "src", value
        else
          $(this).text value
        $(this).trigger "item.changed"
$.fn.CSRFProtection: (xhr) ->
  token = $("meta[name=\"csrf-token\"]").attr("content")
  xhr.setRequestHeader "X-CSRF-Token", token  if token

class Items

  constructor: (element) ->
    document.items ?= {}
    jQuery.ajaxPrefilter (options, originalOptions, xhr) ->
      unless options.crossDomain
        if token = $('meta[name="csrf-token"]').attr('content')
          xhr.setRequestHeader('X-CSRF-Token', token)

    unless element
      element = $('body')

    @discover_items element
    @apply_templates element

  get: => 
    $(@).trigger('item.get')
  patch: => 
    $(@).trigger('item.patch')
  post: => 
    $(@).trigger('item.post')
  delete: => 
    $(@).trigger('item.delete')

  apply_templates: (element) =>
    # console.debug "apply templates to #{element}"

$('body').on 'item.update', 'data#items', ->
  new Items(@)
  $(@).find('[itemscope]').each ->
    item_id = $(@).attr('itemid')
    $(@).remove()
    $("[itemid='#{item_id}']")

$('body').on 'change', "[itemprop]", ->
  # console.debug($(@).parents("form"))
  unless $(@).parents("form").length > 0
    parent = $(@).parents("[itemscope], [itemref]").first()

    unless item_id = $(parent).attr 'itemid'
      item_id = $(parent).attr 'itemref'

    jQuery.ajax
      url: item_id
      headers: {retrieve_as_data: "true"}
      type: 'put'
      data: "#{$(@).attr('itemprop')}=#{Item.get_value(@)}"
      success:  (data) ->
        # console.info "item.updated"
        $('data#items').append(jQuery.parseHTML(data))
        $('data#items').trigger('item.update')

      error: (data, textStatus, jqXHR) ->
        console.error "Error updating this item", data, textStatus, jqXHR

$('body').on 'click', 'details[itemscope]', ->
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
