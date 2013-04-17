class Item
  constructor: (element) ->
    unless element
      element = $('body')
    @discover_items element
    @apply_templates element

  discover_items: (element) ->
    $(element).find("[itemscope]").each (index) ->
      item_type = $(@).attr 'itemtype'
      item_id = $(@).attr 'itemtid' 
      item = {}

      # each item must populate itemtype and itemId
      $(@).find("[itemprop]").each ->
        item_prop = $(@).attr 'itemprop'
        item[item_prop] = Item.get_value(@)

      if item_type
        localStorage[item_type][item_id] = item # assumes the current item is more recent
      else
        localStorage[item_type] = item

    apply_templates: (element) ->
      # apply the mustache templates to the given eoement

$(document).ready ->
  new Item($("body"))

