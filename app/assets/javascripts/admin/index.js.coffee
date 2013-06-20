$(document).on "load.admin_index", ->

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

$('[contenteditable]').on 'blur', ->
  # save the item
  console.debug('content edited')