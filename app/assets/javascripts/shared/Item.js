Item = {
  items: {},
  discover_items: function(){
    $("*[itemscoped]").each(function (index){
      Item.items[$(this).attr("itemtype")] = {}
      var i = Item.items[$(this).attr("itemtype")][$(this).attr('itemid')] = {}
      $(this).find("*[itemprop]").each(function (){
        if(Item.get_value(this)){
          i[$(this).attr('itemprop')] = Item.get_value(this);
        }
      });
    });
    if(Item.items){
      $(document).trigger("items." + $('body').attr('id'));
    }
    return Item.items;
  },
  get_value: function (element){
    if($(element).is("input") || $(element).is("textarea") || $(element).is("select")){
      return $(element).val().trim();
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
  },
  update_page: function(item){
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
    $(document).trigger('items.updated.' + $('body').attr('id'));
  },
  CSRFProtection: function (xhr){
    var token = $('meta[name="csrf-token"]').attr('content');
    if (token) xhr.setRequestHeader('X-CSRF-Token', token);
  }
}
document.getItems = function (type){
  if(type){
    return Item.items[type]
  }
  else{
    return Item.items
  }
}
$(document).ready(function (event){
  $.ajaxPrefilter(function(options, originalOptions, xhr){ if ( !options.crossDomain ) { Item.CSRFProtection(xhr); }});

  Item.discover_items()

  $("*[itemscoped] form").submit(function(event){
    event.preventDefault()

    if($(this).find("*[itemprop]").length == 0){
      return true
    }
    var item_element = $(this).parents('*[itemscoped]')
    var id = $(item_element).attr('itemid')
    var type = $(item_element).attr('itemtype')
    var form = this

    $(this).find('input.invalid').removeClass('invalid');

    $(this).find('*[itemprop]').each(function (){
      if(Item.get_value(this)){
        Item.items[type][id][$(this).attr('itemprop')] = Item.get_value(this);
      }
    });
    Item.update_page(Item.items[type][id]);
    id = id.replace('/new', '')
    jQuery.ajax({
      url: id,
      type: $(this).attr('method'),
      data: $(this).serialize(),
      error: function(data, textStatus, jqXHR) {
        //TODO reload the properties from the server and populate the page with a message
        $(form).trigger('items.error' + $(this).attr('method'));
        console.error("error submiting item form " + id, data, textStatus, jqXHR);
      }
    });
  });
});
