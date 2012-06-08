function Item(element) {
  var me = this
  $(element).find("*[itemprop]").each(function (){
    me[$(this).attr("itemprop")] = Item.get_value(this);
  });
}
Item.discover_items = function(){
  var items = {}
  $("*[itemscoped]").each(function (index){
    items[$(this).attr("itemtype")] = {}
    items[$(this).attr("itemtype")][$(this).attr('itemid')] = new Item(this);
  });
  Item.items = items;
  return Item.items;
}
Item.get_value = function (element){
  if($(element).is("input") || $(element).is("select") || $(element).is("textarea") ){
    return $(element).val().trim();
  }
  else if( $(element).is("a") || $(element).is("link")){
    return $(element).attr('href');
  }
  else if( $(element).is("img") || $(element).is("object") || $(element).is("embed")){
    return $(element).attr('src');
  }
  else {
    return $(element).text().trim();
  }
};
Item.update_page = function (item){
  $.each(item, function(key, value){
    if(value != null){
      $('*[itemprop=' + key + ']').each(function(){
        if($(this).is("input") || $(this).is("select") || $(this).is("textarea") ){
          $(this).val(value);
        }
        else if( $(this).is("a") || $(this).is("link")){
          $(this).attr('href', value);
        }
        else if( $(this).is("img") ||  $(this).is("object") ||  $(this).is("embed")){
          $(this).attr('src', value);
        }
        else {
          $(this).text(value);
        }
      });
    }
  });
  $(document).trigger("copper:update_page_items");
}
document.getItems = function(type){
  if(type){
    return Item.items[type]
  }
  else{
    return Item.items
  }
}
$(document).ready(function (){
  Item.discover_items()
  $("*[itemscoped] form").submit(function(event){
    event.preventDefault()
    var item_element = $(this).parents("*[itemscoped]")
    var id = $(item_element).attr('itemid')
    var type = $(item_element).attr('itemtype')

    $(this).find('*[itemprop]').each(function (){
      Item.items[type][id][$(this).attr('itemprop')] = Item.get_value(this);
    });
    Item.update_page(Item.items[type][id]);
    jQuery.ajax({
      url: "/" + id,
      type: $(this).attr('method'),
      data: $(this).serialize(),
      error: function(data, textStatus, jqXHR) {
        //TODO reload the properties from the server and pop7late the page with a message
        console.error("error submiting form " + $(this).attr('method'), data, textStatus, jqXHR);
      }
    });
  });
});