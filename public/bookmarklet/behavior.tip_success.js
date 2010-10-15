$('section.notify > section > button').click(function(event) {
  $("section.notify").stop(true);
  $(this).addClass("display-form");
  $('body > section.notify > section > form').addClass("display-form");
  $('body > section.notify > section > form textarea').focus();
});

$('section.notify > section > form input').click(function(event){
  event.preventDefault();
  $('section.notify > section > button').removeClass("display-form");
  $('section.notify > section > form').removeClass("display-form");
  $("section.notify").fadeOut(1300);
});

$('section.notify > section > form input[name=save]').click(function(event){
  var tip_id = $("section.notify > section > button").attr('id');
  console.debug(tip_id);
  $.post("/tips/" + tip_id, $("section.notify > section > form").serialize());
});
