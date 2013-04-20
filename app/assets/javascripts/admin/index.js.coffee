$(document).on "load.admin_index", ->
 
  $('nav#models > a').click ->
    $(@).toggleClass('selected')
    
    $("article#{$(@).attr('href')}").toggleClass('selected');

  $("body").on 'click', 'details[itemscope]', ->
    if $(@).attr('open')
      $(@).attr('draggable', 'true')
    else
      # console.debug('opening')
      $(@).attr('draggable', 'false')    
      $(@).trigger('get_details_content');

  $('body').on 'get_details_content', 'details[itemscope]', ->
    # todo: instead of checking for elements i should just turn this event listener off
    unless $(@).find('section').length > 0 || $(@).find('details').length > 0
      # console.debug('getting info')
      jQuery.ajax
        url:$(@).attr('itemid'),
        success: (data) =>
          $(@).append(data)
          # console.debug('element', @)
          new Item_m(@)
          $(@).find('time').timeago()

        statusCode:
          401:=>
            $(@).trigger "401"
 
  $("#pallet").on "drop", ->
    # event.preventDefault()
    # console.debug("drop")
    $(@).removeClass("hover")
    itemid = event.dataTransfer.getData("item")
    # console.debug(  $("[itemid='#{itemid}']"))
    event.target.appendChild($("[itemid='#{itemid}']")[0])
    # return false;

  $("#pallet").on "dragenter", ->
    # event.preventDefault()
    # console.debug("dragenter")
    $(@).addClass("hover")
    return false;

  $("#pallet").on "dragover", ->
    return false;

  $("#pallet").on "dragleave", ->
    # event.preventDefault()
    # console.debug("dragleave")
    $(@).removeClass("hover")
    return false;

  $('[draggable]').on 'dragstart', ->
    # event.preventDefault()
    # console.debug("dragstart")
    $(@).addClass("drag")
    event.dataTransfer.setData('item', $(@).attr('itemid') )

  $('[draggable]').on 'dragend', ->
    # event.preventDefault()
    # console.debug("dragend")
    $(@).removeClass("drag")
