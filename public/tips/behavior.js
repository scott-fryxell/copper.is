$(document).ready(function() {

  if( $("#tip_url").attr("value").length > 0 ){ $('label').fadeOut(2500) }

  $("#tip_url").focus();

  $("#tip_url").keydown(function(event) {
    if(this.value.length > 0){
      $('label').fadeOut();
    }
    else{
      $('label').fadeIn();
    }
  });
});