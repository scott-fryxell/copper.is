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
    // console.debug("determine tip", FLB, location);
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
      $("body > section").fadeIn(800).delay(3500).fadeOut(800, function (event){
        window.parent.postMessage("notify_complete",  "*");
      });
    }
  },
  "terms_accepted": function (event, xhr, options){
    $("#credit_card > h1").text("We'll email you a reciept");
    $("#credit_card > form").slideUp(800, function (){
      $("#credit_card").append("<button>Close</button>");
    });
  },
  "card_declined": function (event, xhr, options){
    $("#credit_card > h1").text("Your credit card was declined");
    // allow them to resubmit with a new card
    $('#credit_card > form > input[type=submit]').removeAttr("disabled");
  },
  "terms_declined": function (event, xhr, options){
    console.debug("credit card problem");
    // TODO Plug some shit in for this
  },
  "processing_error": function (event, xhr, options){
    $("#credit_card > h1").text("There was a processing error. Your credit card was not charged");
    // allow them to resubmit with a new card
    $('#credit_card > form > input[type=submit]').removeAttr("disabled");
  },
  "patch_tip": function (event) {
    $("section.notify > aside > form > button").hide();
    $("body > section").fadeOut(800, function (){
      // filter the amount, make sure that it's a number
      // post the form via ajax.
      // console.debug( "tip is: " + $("section.notify > aside > form > input").val());

      // convert from dollars into cents
      var amount_in_cents = $("section.notify > aside > form > input").val();
      amount_in_cents = Math.round(100 * parseFloat(amount_in_cents.replace(/[$,]/g, '')));

      $.ajax({
        url:$("section.notify > aside > form").attr("action"),
        data:  "tip[amount_in_cents]=" + amount_in_cents,
        type: "PUT",
        success: function(data) {
          // console.debug(data);
          window.parent.postMessage("notify_complete",  "*");
        }
      });

    });

  }
});

$("footer > section > button").live('click', function (event){
  $('footer').slideUp(800, function (){
    $("body > section").fadeOut(800, function (){
      window.parent.postMessage("notify_complete",  "*");
    });
  });
});

$("section.notify > aside > form").live('submit', function (event){
  event.preventDefault();
  $(document).trigger("patch_tip");
});

$("section.notify > aside > form > button").live('click', function (event){
  if ($(this).text() == "Change") {
    $("section.notify > aside > form > input").removeAttr('readonly')
    $("section.notify > aside > form > input").focus();

    $(this).text("save");
    $("body > section").stop(true);
    $("section.notify > aside > form").focus();
  }
  else {
    $(document).trigger("patch_tip");
  }
});
var FLB = {
  tip: {}
}
