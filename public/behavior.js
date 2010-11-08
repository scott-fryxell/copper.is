$(document).ready(function () {
  $('body > section > header > span').click(function () {
    $(document).trigger("minimize_call_to_action");
  });

  if( $.cookie('showed_cta') ) {
    $(document).trigger("minimize_call_to_action");
  }
  else {
    $.cookie('showed_cta', 'yep', { expires: 30*3});
  }

  $(document).trigger("poll_for_tips");
});

$(document).bind("minimize_call_to_action", function (event) {
  if ( $('body > section > header').hasClass('minimized') ){
    $('body > section > header').removeClass('minimized');
    $('body > section > header > span').text('X');
  }
  else {
    $('body > section > header').addClass('minimized');
    $('body > section > header > span').text('V');
  }
});

$(document).bind("tip_carousel", function(){
  // fade in a tip
  $('*[itemtype=http://weave.us/tip]')

})

