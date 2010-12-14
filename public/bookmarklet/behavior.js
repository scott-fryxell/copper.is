var FLB = {
  tip: {}
};

$(document).ready(function() {
   $(document).trigger("tip_determine");
   $(document).trigger("tip_token_get");
   $(document).trigger("tip_submit");
});

$(document).bind("tip_determine", function (event, xhr, options){

  var location = new String(window.location);

  //assumes loaded in an iframe with  the url to be tipped appended
  if(location.split("#/")[1] && location.split("&title=")[1] ){
    FLB.tip = {
      uri: location.split("#/")[1].split("&title=")[0],
      title: location.split("&title=")[1],
    };
  }
});

$(document).bind("tip_token_get", function (event, xhr, options){
  // get authenticity token
  $.ajax({
    url: "/tips/new.js",
    async:false
  });
});

$(document).bind("tip_submit", function (event, xhr, options){
  if(FLB.tip.authenticity_token != null){
    $.ajax({
      url:"/tips",
      data: FLB.tip,
      type: "POST"
    });
  }
});

$(document).bind("tip_success", function (event, xhr, options){
  $(document).trigger("notify", xhr, options);
});

$(document).bind("tip_error", function (event, xhr, options){
  /*
    TODO implement or remove.
  */
  $(document).trigger("alert_start", xhr);
  console.debug("there was a tip error", xhr, event);
});

$(document).bind("login_submit", function (event, options){
  $.post("/authenticate", $("section.workflow form").serialize());
  $(document).trigger("workflow_end");
});

$(document).bind("login_get", function (event){
  $("section.workflow ").load('/signin');
});

$(document).bind("login_display", function (event){
  $("section.workflow > form").submit(function (event){
    event.preventDefault();
    $(document).trigger("login_submit");
    return false;
  });

  $("section.workflow > header > .click").click(function (){
    $(document).trigger("end_workflow");
    return false;
  });

  $(document).trigger("workflow_start");
  $("input[id=email]").delay(1200).focus();
});

$(document).bind("login_success", function (event){
  $(document).trigger("tip_token_get");
  $(document).trigger("tip_submit");
});

$(document).bind("401", function (event, response, options){
  $(document).trigger("login_get");
});
