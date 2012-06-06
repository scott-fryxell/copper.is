//= require shared/common
window.parent.postMessage("resize_frame",  "*");
$(document).ready(function(event){
  $("span").click(function(){
    window.parent.postMessage("notify_complete",  "*");
  });
});
