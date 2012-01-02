$(document).ready(function() {
  window.parent.postMessage("resize_frame",  "*");
  $(document).trigger($("meta[name=event_trigger]").attr("content"));
});
$(document).bind({
  "tip_determine": function (event, xhr, options) {
    var location = new String(window.location);
    //assumes loaded in an iframe with  the url to be tipped appended
    if(location.split("#/")[1] && location.split("&title=")[1] ){
      FLB.tip = {
        uri: location.split("#/")[1].split("&title=")[0],
        title: location.split("&title=")[1],
      };
      FLB.tip.authenticity_token = $('meta[name=csrf-token]').attr('content')
    }
    if(!FLB.uri){
      window.parent.postMessage("reset_frame",  "*");
    }
    console.debug("determine tip", FLB, location);
  },
  "tip_submit": function (event, xhr, options) {
    if(FLB.tip.authenticity_token != null){
      $.ajax({
        url:"/users/current/tips",
        data: FLB.tip,
        type: "POST"
      });
    }
  },
  "ajaxComplete": function (event, xhr, options) {
    $("body").append(xhr.responseText);
    $(document).trigger(new String(xhr.status), xhr, options);
  },
  "401": function (event, response, options) {
    $(document).trigger("login_get");
  },
  "200": function (event, xhr, options){
    var trigger = $("<div />").append(xhr.responseText).find("meta[name=event_trigger]").attr("content");
    if(trigger){
      $(document).trigger(trigger, xhr, options);
    }
  },
  "notify": function (event, xhr, options) {
    if($('footer')[0]){
      $("body > section").fadeIn(800, function (){
        $('footer').slideDown(800, function (){
          $('#credit_card').show(500);
        });
      });
    } else {
      $("body > section").fadeIn(800).delay(3500).fadeOut(800);
    }
  }
});
var FLB = {
  tip: {}
}