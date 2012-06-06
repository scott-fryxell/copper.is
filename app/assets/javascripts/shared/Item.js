function Item(element) {
  this.url = $(element).attr('itemid');
  this.element = element;
  var temp_props = {};
  var value;

  $(element).find("*[itemprop]").each(function (){
    if($(this).is("input") || $(this).is("select") || $(this).is("textarea") ){
      value = $(this).val();
    }
    else if( $(this).is("a") || $(this).is("link")){
      value = $(this).attr('href');
    }
    else if( $(this).is("img") || $(this).is("object") || $(this).is("embed")){
      value = $(this).attr('src');
    }
    else {
      value = $(this).text().trim();
    }
    temp_props[$(this).attr("itemprop")] = value
  });
  this.props = temp_props
}
Item.prototype.get = function(){};
Item.prototype.put = function(){
  jQuery.ajax({
    url: "put",
    type: $(this).attr("method"),
    data: $(this).serialize(),
    success: function(data, textStatus, jqXHR) {
      $(this).parents("*[itemscoped]")
    },
    error: function(data, textStatus, jqXHR) {
      console.error("error updating form form", data, textStatus, jqXHR);
    }
  });
};
Item.prototype.post = function (){};
Item.prototype.delete = function (){};

Item.prototype.sync_property = function (property, value){
  if($(property).is("input") || $(property).is("select") || $(property).is("textarea") ){
    return $(property).val(value);
  }
  else if( $(property).is("a") || $(property).is("link")){
    return $(property).attr('href', value);
  }
  else if( $(property).is("img") ||  $(property).is("object") ||  $(property).is("embed")){
    return $(property).attr('src', value);
  }
  else {
    return $(property).text(value);
  }
}

Item.prototype.save = function (){
  $.each(this.props, function(key, value){
    console.debug(key, value )
    if(value != null){
      $('*[itemprop=' + key + ']').each(function(){
        item.sync_property(this, value);
      });
    }
  });
}