$(document).on "load.authors_edit", ->

  $("#identities > header > a").click (event) -> 
    event.preventDefault();
    $('#identities').toggleClass 'edit'

    if $('#identities').hasClass 'edit'
      $('#identities > header > a').text 'Done'
    else
      $('#identities > header > a').text 'Add/Remove'
  
  $('#identities > aside > nav > a > img, #identities form > input').click ->
    $(this).addClass 'working'

  $("#identities form").on 'item.delete', ->
    $(this).parent().addClass('deleted').remove()
    if 2 > $("#identities form").size()
      $('#identities figure > form').addClass 'hide'

$(document).on 'me.authors_edit', ->
  if copper.me.country_code
    $("select[itemprop=country_code]").change()
  else
    $("#address > header > a").click()

$(document).on "form.states", ->
  $("option[value=#{copper.me.subregion_code}]").attr('selected','selected')