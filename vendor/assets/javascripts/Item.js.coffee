class Item
  constructor: (element) ->
    unless element
      element = $('body')
    @discover_items element

  discover_items: ->

$(document).ready ->
  new Item($("body"))

