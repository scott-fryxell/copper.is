//= require jquery
//= require jquery.cookie
//= require jquery.timeago
//= require jquery.tmpl
//= require shared/Item
$(document).ready(function() {
  jQuery('time').timeago();
});

$(document).ready(function (){
  $("*[itemscoped] form").submit(function(event){
    event.preventDefault()
    data = $(this).serialize() + ',authenticity_token=' + $('meta[name=csrf-token]').attr('content');
    console.debug("form submited", data);
  });
});

document.getItems = function(item_type){
  var items = {}
  $("*[itemscoped]").each(function (index){
    items[$(this).attr("itemtype")] = []
    items[$(this).attr("itemtype")][index] = new Item(this);
  });
  return items;
}
