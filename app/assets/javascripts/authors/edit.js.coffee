$(document).on "load.authors_edit", ->

  $("section#identities > header > a").click (event) -> 
    event.preventDefault();
    $('section#identities').toggleClass 'edit'
  
  $("section#identities > aside > nav > a > img").click ->
    $(this).addClass 'working'