jQuery.ajaxPrefilter (options, originalOptions, xhr) ->
  unless options.crossDomain
    if token = $('meta[name="csrf-token"]').attr('content')
      xhr.setRequestHeader('X-CSRF-Token', token)

jQuery.update_view = (item) ->
  $('html').update_view(item)

jQuery.items = ->
  $('html').items()

jQuery.page_scope = ->
  "#{$('body').attr('class').replace(' ','.')}".trim()

jQuery.fn.extend

  items: ->
    document.items = {}

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

    return document.items

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

  update_view: ->
    console.log('updating view', @)
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
