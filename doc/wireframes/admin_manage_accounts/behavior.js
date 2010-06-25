$(document).ready(function() {
  console.debug("inside behavior");
  $("#tip").focus();
  $("#tip").keydown(function(event) {
    console.debug(this.value.length);
    if(this.value.length >= 1){
      console.debug("inside legend");
      $('legend').fadeOut();
    }
    else{
      $('legend').fadeIn();
    }
  });
});