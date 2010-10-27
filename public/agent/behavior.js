$(document).ready(function() {
  $("section.alert > header > span").click(function(){
    $(document).trigger("alert_end");
  });
});

$(document).bind("ajaxComplete", function (event, xhr, options) {
  $(document).trigger(new String(xhr.status), xhr, options);
});

$(document).bind("200", function (event, xhr, options){
  var trigger = $("<div />").append(xhr.responseText).find("meta[name=event_trigger]").attr("content");
  if(trigger){
    $(document).trigger(trigger, xhr, options);
  }
});

$(document).bind("notify", function (event, xhr, options) {
  $("section.notify").append(xhr.responseText);
  $("body").addClass("open");

  $("section.notify").fadeIn(800).delay(1000).fadeOut(800, function(){
    window.parent.postMessage("notify_complete",  "*");
    $("body").removeClass("open");
  });

});

$(document).bind("open", function (event, url) {
  window.open(url);
});

$(document).bind("workflow_start", function (event, xhr) {
  $("body").addClass("open");
  $("section.workflow > header > .close").click(function(){
    $(document).trigger("workflow_end");
  });

  $("section.workflow").slideToggle(1200);
});

$(document).bind("workflow_end", function (event) {
  $("body").removeClass("open");
  $("body").focus();
  $("section.workflow > header > .close").unbind();
  $("section.workflow").slideToggle(1000);
});

$(document).bind("alert_start", function (event, xhr) {
  $("section.alert ol").append("<li>" +  Message[xhr.status] + "</li>");
  $("section.alert").fadeIn(500);
});

$(document).bind("alert_end", function (event, xhr) {
  $("section.alert ol").empty();
  $("section.alert").fadeOut("slow");
});

$(document).keyup(function(event) {

  /*
    TODO needs to be aware of what mode app is in (workflow, open, notify, alert)
  */
  if (event.keyCode == 27 ){
    if($("body.open").length == 1 )
      $(document).trigger("notify");
    else
      $(document).trigger("notify");
  }

});

