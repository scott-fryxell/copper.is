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
    $(this).parent().remove()
    if 2 > $("#identities form").size()
      $('#identities figure > form').addClass 'hide'

  $("#address form").on 'item.validate', ->
    unless $('#address form .invalid').size == 0
      $('p[itemprop=payable_to]').text($(this).find('input[itemprop=payable_to]').val())
      $('p[itemprop=line1]').text($(this).find('input[itemprop=line1]').val())
      $('p[itemprop=line2]').text($(this).find('input[itemprop=line2]').val())
      $('span[itemprop=city]').text($(this).find('input[itemprop=city]').val())
      $('span[itemprop=subregion_code]').text($(this).find('select[itemprop=subregion_code]').val())
      $('span[itemprop=postal_code]').text($(this).find('input[itemprop=postal_code]').val())

$(document).on 'me.authors_edit', ->
  if copper.me.country_code
    $("select[itemprop=country_code]").change()
  else
    $("#address > header > a").click()

