
$('form[target=interact]').live("submit", function (event){
  event.preventDefault();
  $(this).addClass("working");

  var post_data;
  var item  = $(this).closest('*[item=true]');

  var resource = $(item).data('resource') || {};


  $(this).find("*[itemprop]").each(function (){
    console.debug($(this).attr('type'));
    if('checkbox' == $(this).attr('type') && $(this).attr('checked')){
      resource[$(this).attr('name')] =  determine_value(this);
    }
    else {
      resource[$(this).attr('name')] =  determine_value(this);
    }
  });

  if($(this).attr('itemtype') == 'form'){
    post_data = $(this).serialize();
  }
  else{
    post_data = 'resource=' + JSON.stringify(resource);
  }


  var form = this
  var action = $(this).attr("action");
  var method = $(this).attr("method");
  console.debug("posting to server", method + ":" + action, post_data);
  // hide_details_for(action.subString( action.lastIndexOf("#") ) );

  jQuery.ajax({
    url: action,
    type: method,
    data: post_data,
    success: function(data, textStatus, jqXHR) {
      console.info(textStatus, data);
      $(item).data('resource', data);

      $(form).removeClass("working");

      if ($(form).attr("itemtype") != 'form') {
        update_page(data);
      }
      console.debug(method + ":" + action);
      $(document).trigger(method + ":" + action, [form, data]);
      console.log('resource submit returned')
    },
    error: function(data, textStatus, jqXHR) {
      console.error("error posting to " + action, data, textStatus, jqXHR);
    }

  });
});
$('body *[rel=interact]').live("click", function (event){

  $(document).trigger("get:" + this.hash, [this]);
  if(jQuery.browser.msie){
    event.preventDefault();
  }
  else {
    history.pushState(null, '', this.href);
  }
  event.preventDefault();
});
function determine_value(property){
  if($(property).attr("itemvalue")){
    return $(property).attr("itemvalue")
  }
  else if( 'INPUT' ==  property.tagName ){
    return $(property).attr('value');
  }
  else if( 'A' == property.tagName ){
    return $(property).attr('href');
  }
  else if( 'LINK' == property.tagName ){
    return $(property).attr('href');
  }
  else if( 'IMG' == property.tagName ){
    return $(property).attr('src');
  }
  else if( 'TEXTAREA' == property.tagName ){
    return $(property).val();
  }
  else {
    if($(property).text().trim())
      return $(property).text().trim();
    else
      return {}
  }
}
function update_property(property, value){

  if($(property).attr("itemvalue")){
    //this jamms up selecting a font
    // $(property).attr("itemvalue", value)
  }
  else if( 'INPUT' ==  property.tagName ){
    $(property).attr('value', value);
  }
  else if( 'TEXTAREA' ==  property.tagName ){

    $(property).val($.trim(value));
  }

  else if( 'A' == property.tagName ){
    $(property).attr('href', value);
  }
  else if( 'LINK' == property.tagName ){
    $(property).attr('href', value);
  }
  else if( 'IMG' == property.tagName ){
    $(property).attr('src', value);
  }
  else {
    // console.debug("else element:", property.tagName)
    return $(property).text(value);
  }
}
function update_page(resource){
  $.each(resource, function(key, value){
    if(value != null){
      $('*[itemprop=' + key + ']').each(function(){
        update_property(this, value);
      });
    }
  });
}

/*
  TODO move this to it's own directory.
*/
var JSON = JSON || {};
// implement JSON.stringify serialization
JSON.stringify = JSON.stringify || function (obj) {
  var t = typeof (obj);
  if (t != "object" || obj === null) {
    // simple data type
    if (t == "string") obj = '"'+obj+'"';
    return String(obj);
  }
  else {
    // recurse array or object
    var n, v, json = [], arr = (obj && obj.constructor == Array);
    for (n in obj) {
      v = obj[n]; t = typeof(v);
      if (t == "string") v = '"'+v+'"';
      else if (t == "object" && v !== null) v = JSON.stringify(v);
      json.push((arr ? "" : '"' + n + '":') + String(v));
    }
    return (arr ? "[" : "{") + String(json) + (arr ? "]" : "}");
  }
};
