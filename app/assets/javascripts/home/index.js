$(document).ready(function (){
  $('#call_to_action').bind('rotate',  function(event){
    var  li   =  $(this).find('ul   >  li:visible');
    $(li).hide(500);

    if($(li).next().length == 0){
      li = $(this).find('ul > li:first-child').show(500);
    }
    else {
      $(li).next().show(500);
    }
    setTimeout(function() {
      $('#call_to_action').trigger('rotate');
    }, 5000);
  });
  setTimeout(function() {
    $('#call_to_action').trigger('rotate');
  }, 6000);
});

