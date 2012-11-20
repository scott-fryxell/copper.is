$(document).on "load.authors_edit", ->

  $("#identities > header > a").click (event) -> 
    event.preventDefault();
    $('#identities').toggleClass 'edit'

    if $('#identities').hasClass 'edit'
      $('#identities > header > a').text 'Done'
    else
      $('#identities > header > a').text 'Add/Remove'
  
  $('#identities > aside > nav > a > img,
     #identities > div > figure > form > input').click ->
    $(this).addClass 'working'

  $("#identities form").on 'item.delete', ->
    $(this).parent().addClass('deleted').remove()
    console.debug($("#identities form").size())
    if 2 > $("#identities form").size()
      $('#identities figure > form').addClass('hide')