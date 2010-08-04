$(document).ready(function() {
  
  $("body > section > header > nav > a").click(function(event){
    $("a.selected").removeClass("selected");
    $("ol.selected").removeClass("selected");
    $(this).addClass("selected");
    $( "#" + this.href.split("#")[1] ).addClass("selected");
    event.preventDefault();
 });
});