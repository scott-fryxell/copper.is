$(document).ready(function() {

  if( $("#uri").attr("value").length > 0 ){ $('label').fadeOut(2500) }

  $("#uri").focus();

  $("#uri").keydown(function(event) {
    if(this.value.length > 0){
      $('label').fadeOut();
    }
    else{
      $('label').fadeIn();
    }
  });
});