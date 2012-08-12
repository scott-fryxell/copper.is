$(document).on("items.users_edit items.authors_edit", function (){
  $("section > header > a").click(function(event){
    event.preventDefault();
    var div = $(this).parents("section").find("div");
    var form = $(this).parents("section").find("form")
    $(this).animate({opacity:0}, 200);
    div.animate({opacity:0},500, function (){
      div.css("display", "none")
      form.css("display", "inline-block")
      form.animate({opacity:1},500);
    });
  });
  $("section > form").submit(function(event){
    event.preventDefault()
    div = $(this).parents("section").find("div")
    $(this).animate({opacity:0},500, function (){
      $(this).css("display", "none")
      $(this).parents("section").find("header > a").animate({opacity:1}, 200)
      div.css("display","inline-block")
      div.animate({opacity:1}, 500)
    });
  });

  $('#email form').bind('copper.invalid', function (){
    $('#email > header > a').click();
    $(this).find('input[itemprop=email]').addClass('invalid');
  });

  $('#address > form > fieldset > select').change(function (event){
    $("select[itemprop='subregion_code']").remove();

    $.get('/states?country_code=' + $(this).val(), function (data){
      $('#address > form > fieldset').append(data);
    });
  });
  
});