//= require shared/current_user
//= require shared/tip_rate
window.parent.postMessage("reset_frame",  "*");
$(document).ready(function() {
  if(window.location.hash == ""){
    $(document).trigger('#active_tips');
  }
  $('td > form').bind('submit', function(){
    $(this).parent().parent().addClass('destroyed');
  });
});
$(document).bind("#all_tips", function(event){
  $('#active_tips').css('opacity', '.5');
});
$(document).bind("#active_tips", function(event){
  $('#all_tips').css('opacity', '.5');
});
$(document).bind("get:current_user", function(event){
  $('#new_tip').attr('action', '/users/' + current_user.id + '/tips');
});