$(document).ready(function() {
  $(document).trigger("tip_determine");
  $(document).trigger("tip_token_get");
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
    }
    if(!FLB.uri){
      window.parent.postMessage("reset_frame",  "*");
    }
    console.debug("determine tip", FLB, location);
  },
  "tip_token_get": function (event, xhr, options) {
    // get authenticity token
    $.ajax({
      url: "/tips/new.js",
      async:false
    });
  },
  "tip_submit": function (event, xhr, options) {
    if(FLB.tip.authenticity_token != null){
      $.ajax({
        url:"/tips",
        data: FLB.tip,
        type: "POST"
      });
    }
  },
  "tip_success": function (event, xhr, options) {
    $(document).trigger("notify", xhr, options);
  },
  "tip_error": function (event, xhr, options) {
    $("section.alert > header > span").click(function(){
      $(document).trigger("alert_end", xhr);
    });
    $(document).trigger("alert_start", xhr);
    console.error("there was a tip error", xhr, event);
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
  "401": function (event, response, options) {
    $(document).trigger("login_get");
  },
  "ajaxComplete": function (event, xhr, options) {
    $(document).trigger(new String(xhr.status), xhr, options);
  },
  "200": function (event, xhr, options){
    var trigger = $("<div />").append(xhr.responseText).find("meta[name=event_trigger]").attr("content");
    if(trigger){
      $(document).trigger(trigger, xhr, options);
    }
  },
  "notify": function (event, xhr, options) {
    $("section.notify").append(xhr.responseText);
    $("body").addClass("open");

    $("section.notify").fadeIn(800).delay(3000).fadeOut(800, function(){
      window.parent.postMessage("notify_complete",  "*");
      $("body").removeClass("open");
    });
  },
  "open": function (event, url) {
    window.open(url);
  },
  "alert_start": function (event, xhr) {
    $("section.alert ol").append("<li>" +  Message[xhr.status] + "</li>");
    $("section.alert").fadeIn(500);
  },
  "alert_end": function (event, xhr) {
    $("section.alert ol").empty();
    $("section.alert").fadeOut("slow");
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
};
