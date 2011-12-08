//= require jquery
//= require jquery.cookie
//= require jquery.timeago
//= require jquery.tmpl
//= require resource
//= require analytics
window.parent.postMessage("resize_frame",  "*");
$(document).ready(function(event){
  $("span").click(function(){
    window.parent.postMessage("notify_complete",  "*");
  });
  $("nav > a > img").click(function(event){
    $(this).addClass("working");
  });
});
