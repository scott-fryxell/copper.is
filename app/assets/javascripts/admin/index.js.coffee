$(document).on "load.admin_index", ->
  
  $('nav#models > a').click ->
    $(@).toggleClass('selected')
    
    $("article#{$(@).attr('href')}").toggleClass('selected');

  $("details[itemscoped]").click ->
    unless $(@).attr('open')
      details = @
      jQuery.ajax
        url:$(@).attr('itemid'),
        success: (data) ->
          $(details).append(data)
        statusCode:
          401:->
            $(document).trigger "401"

  $("#pallet").on "drop", ->
    # event.preventDefault()
    console.debug("drop")
    $(@).removeClass("hover")
    # event.preventDefault()
    itemid = event.dataTransfer.getData("item")
    console.debug(  $("[itemid='#{itemid}']"))
    event.target.appendChild($("[itemid='#{itemid}']")[0])
    # return false;

  $("#pallet").on "dragenter", ->
    # event.preventDefault()
    console.debug("dragenter")
    $(@).addClass("hover")
    return false;

  $("#pallet").on "dragover", ->
    return false;

  $("#pallet").on "dragleave", ->
    # event.preventDefault()
    console.debug("dragleave")
    $(@).removeClass("hover")
    return false;

  $('[draggable]').on 'dragstart', ->
    # event.preventDefault()
    console.debug("dragstart")
    $(@).addClass("drag")
    event.dataTransfer.setData('item', $(@).attr('itemid') )
    # event.dataTransfer.setData("Text",event.target.id)

  $('[draggable]').on 'dragend', ->
    # event.preventDefault()
    console.debug("dragend")
    $(@).removeClass("drag")
