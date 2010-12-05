$(document).ready(function () {
  $('body > section > header > span').click(function () {
    $(document).trigger("minimize_call_to_action");
  });

  if( $.cookie('showed_cta') ) {
    $(document).trigger("minimize_call_to_action");
  }
});

$(document).bind("minimize_call_to_action", function (event) {
  if ( $('body > section > header').hasClass('minimized') ){
    $('body > section > header').removeClass('minimized');
    $('body > section > header > span').text('X');
    $.cookie('showed_cta', null, { expires: 30*3});
  }
  else {
    $('body > section > header').addClass('minimized');
    $('body > section > header > span').text('V');
    $.cookie('showed_cta', 'yep', { expires: 30*3});
  }
});
