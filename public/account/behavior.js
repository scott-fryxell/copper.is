$(document).ready(function () {
  $('details > summary').click(function (event){
    if ($(this).parent('details').attr('open') == 'open')
      $(this).parent('details').attr('open', 'close')
    else
      $(this).parent('details').attr('open', 'open')
  });

  $('details#bookmarklet > p > a ').bind('dragend', function (event) {
    $('details#bookmarklet').removeClass('required');
    $('details#bookmarklet').addClass('completed');
    $('details#bookmarklet > summary').click();
  })

  $('details#tip_rate > form > fieldset > select').click(function (event) {
    $('details#tip_rate').removeClass('required');
    $('details#tip_rate').addClass('completed');
    $('details#tip_rate > summary').click();
  });

});


