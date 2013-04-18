class Item_m

  constructor: (element) ->
    unless @items = document.items
      @items = {}

    unless element
      element = $('body')

    # console.debug('gathering item data', element, @items)
    @discover_items element
    @apply_templates element
    document.items = @items

  discover_items: (element) =>
    items = @items
    $(element).find("[itemscope]").each ->
      item_type = $(@).attr 'itemtype'
      item_id = $(@).attr 'itemid' 
      item = {}

      $(@).find("[itemprop]").each ->
        item_prop = $(@).attr 'itemprop'
        # console.debug(item_prop, Item.get_value(@) )
        item[item_prop] = Item.get_value(@)

      # console.debug(item_type)
      if item_type
        unless items[item_type]
          items[item_type] = {}
        items[item_type][item_id] = item 

      else
        items[item_id] = item
    
    console.debug(@items)

  apply_templates: (element) ->
    # apply the mustache templates to the given element
    console.debug("apply templates to #{element}")

window.Item_m = Item_m

$(document).ready ->
  localStorage.clear()
  new Item_m()