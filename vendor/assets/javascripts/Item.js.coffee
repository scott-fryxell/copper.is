class Items

  constructor: (element) ->
    unless @items = document.items
      @items = {}

    unless element
      element = $('body') # parse the document for items

    # console.debug('gathering item data', element, @items)
    @discover_items element
    @apply_templates element
    document.items = @items

  discover_items: (element) =>
    items = @items
    $(element).find("[itemscope]").each ->
      @.get = ->
        $(@).trigger('item.get')
      @.patch = ->
        $(@).trigger('item.patch')
      @.post = ->
        $(@).trigger('item.post')
      @.delete = ->
        $(@).trigger('item.delete')

      item_type = $(@).attr 'itemtype'
      item_id = $(@).attr 'itemid'
      item = {}
      $(@).find("[itemprop]").each ->
        if item_id == $(@).parents("[itemscope]").first().attr('itemid')
          item_prop = $(@).attr 'itemprop'
          item[item_prop] = Item.get_value(@)

      if item_type
        unless items[item_type]
          items[item_type] = {}
        items[item_type][item_id] = item
      else
        items[item_id] = item

  apply_templates: (element) =>
    # console.debug "apply templates to #{element}"

$('body').on 'item.get', "[itemscope]", ->
  console.debug("get updated info about me", @)
  # call the itemid with the get method
$('body').on 'item.patch', "[itemscope]", ->
  # call the itemid with the put method
  console.debug("update the server about me", @)
$('body').on 'item.post', "[itemscope]", ->
  console.debug("create a new thing out of me", @)
  # call the itemid with the post method
$('body').on 'item.delete', "[itemscope]", ->
  console.debug("delete me", @)
  # call the itemid with the delete method
$('body').on 'item.update', 'data#items', ->
  new Items(@)
  $(@).find('[itemscope]').each ->
    item_id = $(@).attr('itemid')
    $(@).remove()
    $("[itemid='#{item_id}']")
$('body').on 'change', "[itemprop]", ->
  parent = $(@).parents("[itemscope]").first()
  jQuery.ajax
    url: $(parent).attr('itemid')
    headers: {retrieve_as_data: "true"}
    type: 'put'
    data: "#{$(@).attr('itemprop')}=#{Item.get_value(@)}"
    success:  (data) ->
      console.info "item.updated"
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

$(document).ready ->
  new Items()