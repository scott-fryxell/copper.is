//= require jquery
//= require jquery.cookie
//= require jquery.timeago
//= require jquery.tmpl
//= require shared/Item
$(document).ready(function() {
  jQuery('time').timeago();
});

Copper = {
  format_cents_to_dollars: function(property_name){
    var rate = $("p[itemprop="+ property_name +"]").text().trim()
    rate = (parseFloat(rate) / 100.00)
    if( rate == 0.5 || rate == 0.1){
      rate = rate + '0'
    }
    $("p[itemprop=" + property_name +"]").text(rate)
  }
}
