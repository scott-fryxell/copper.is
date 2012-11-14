$(document).on("load.authors_edit", function (){

  $("section#identities > header > a").click(function(event){
    event.preventDefault();
    $('section#identities').toggleClass('edit')
  });

  $("section#identities > aside > nav > a > img").click(function(event){
    $(this).addClass('working')
  });


});