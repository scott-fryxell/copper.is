$('body > section > details > summary').live("click.display", function (event){
  $('body > section > details[open=closed]').hide().show()
  $(this).parent().hide();
  $(this).parent().show();
});