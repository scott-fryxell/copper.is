function Item(element){
  var me = this
  $(element).find("*[itemprop]").each(function (){
    me[$(this).attr("itemprop")] = Item.get_value(this);
  });
}
Item.discover_items = function (){
  var items = {}
  $("*[itemscoped]").each(function (index){
    items[$(this).attr("itemtype")] = {}
    items[$(this).attr("itemtype")][$(this).attr('itemid')] = new Item(this);
  });
  Item.items = items;
  $(document).trigger("copper:items_discovered");
  return Item.items;
}
Item.get_value      = function (element){
  if($(element).is("input") || $(element).is("select") || $(element).is("textarea") ){
    if($(element).val()){
      return $(element).val().trim();
    }
  }
  else if( $(element).is("a") || $(element).is("link")){
    return $(element).attr('href');
  }
  else if( $(element).is("img") || $(element).is("object") || $(element).is("embed")){
    return $(element).attr('src');
  }
  else {
    if($(element).text()){
      return $(element).text().trim();
    }
  }
}
Item.update_page    = function (item){
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
Item.prototype.update_page = function (){
  Item.update_page(this);
}
document.getItems   = function (type){
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

    if($(this).find("*[itemprop]").length == 0){
      return true
    }

    var item_element = $(this).parents("*[itemscoped]")
    var id = $(item_element).attr('itemid')
    var type = $(item_element).attr('itemtype')
    var form = this

    $(this).find('input.invalid').removeClass('invalid');

    $(this).find('*[itemprop]').each(function (){
      Item.items[type][id][$(this).attr('itemprop')] = Item.get_value(this);
    });
    Item.update_page(Item.items[type][id]);
    console.debug(id)
    if(id =='new'){
      id="/tips"
    }
    jQuery.ajax({
      url: id,
      type: $(this).attr('method'),
      data: $(this).serialize(),
      error: function(data, textStatus, jqXHR) {
        //TODO reload the properties from the server and populate the page with a message
        $(form).trigger("form:invalid");
        console.error("error submiting form " + $(form).attr('method'), data, textStatus, jqXHR);
      }
    });
  });
});
