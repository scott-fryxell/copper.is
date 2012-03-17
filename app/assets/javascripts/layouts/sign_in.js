//= require jquery
//= require jquery.cookie
//= require jquery.timeago
//= require jquery.tmpl
window.parent.postMessage("resize_frame",  "*");
$(document).ready(function(event){
  $("span").click(function(){
    window.parent.postMessage("notify_complete",  "*");
  });
});
