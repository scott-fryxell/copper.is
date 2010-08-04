$(document).ready(function() {

  var url = window.location + "";

  if( url.search("#") == -1) {
    var a = $("body > section > header > nav > a:first-child");
    a.addClass("selected");
    $("#" + a.attr("href").split("#")[1] ).addClass("selected");
  }
  else{
    var fragment = "#" + url.split("#")[1];
    $(fragment).addClass("selected");
    $("a[href=" + fragment +"]").addClass("selected");
  }

  $("body > section > header > nav > a").click(function(event){
    $("a.selected").removeClass("selected");
    $("ol.selected").removeClass("selected");
    $(this).addClass("selected");
    $( "#" + this.href.split("#")[1] ).addClass("selected");
    event.preventDefault();
 });
});