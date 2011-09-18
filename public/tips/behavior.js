$(document).ready(function() {

  $('td > form').bind('submit', function(){
    $(this).parent().parent().addClass('destroyed');
  });

});