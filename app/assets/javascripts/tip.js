$(document).ready(function() {
  window.parent.postMessage("resize_frame",  "*");
  $(document).trigger("tip_determine");
  $(document).trigger("tip_submit");
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
  "login_submit": function (event, options) {
    $.post("/authenticate", $("section.workflow form").serialize());
    $(document).trigger("workflow_end");
  },
  "login_get": function (event) {
    $("section.workflow ").load('/signin');
  },
  "login_display": function (event) {
    $("section.workflow > form").submit(function (event){
      event.preventDefault();
      $(document).trigger("login_submit");
      return false;
    });


    $(document).trigger("notify");
    $("input[id=email]").delay(1200).focus();
  },
  "login_success": function (event) {
    $(document).trigger("tip_token_get");
    $(document).trigger("tip_submit");
  },
  "ajaxComplete": function (event, xhr, options) {
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
    $("body").append(xhr.responseText);
    $("body").addClass("open");
    $("body > section").fadeIn(800).delay(3500).fadeOut(800, function(){
      window.parent.postMessage("notify_complete",  "*");
      $("body").removeClass("open");
    });
  },
  "open": function (event, url) {
    window.open(url);
  },
  "keyup": function(event) {
    if (event.keyCode == 27 ){
      if($("body.open").length == 1 )
        $(document).trigger("notify");
      else
        $(document).trigger("notify");
    }
  }
});
var FLB = {
  tip: {}
}