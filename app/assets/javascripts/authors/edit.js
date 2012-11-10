$(document).on("load.authors_edit", function (){

  $("section#identities > header > a").click(function(event){
    event.preventDefault();
    $('section#identities').addClass('edit')
  });

});