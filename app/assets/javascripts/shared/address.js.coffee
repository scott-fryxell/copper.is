$(document).on "load.identities_edit items.authors_edit", ->
  $('#address > form > fieldset > select').change ->
    $("select[itemprop='subregion_code']").remove()

    jQuery.get "/states?country_code=#{$(this).val()}", (data) ->
      $('#address > form > fieldset').append(data)

  $('#address > form').submit (event) ->
    event.preventDefault()
    $(document).trigger('form.validate_address')
    if($("#address form .invalid"))
      $("#address > header > a").click();

$(document).on "form.validate_address", ->
  $('#address input').removeClass("invalid");
  $('#address select').removeClass("invalid");

  if( 4 > $('input[itemprop=payable_to]').val().length)
    $('input[itemprop=payable_to]').addClass('invalid')
  if( 4 > $('input[itemprop=line1]').val().length)
    $('input[itemprop=line1]').addClass('invalid')
  if( 4 > $('input[itemprop=city]').val().length)
    $('input[itemprop=city]').addClass('invalid')
  if( 4 > $('input[itemprop=postal_code]').val().length)
    $('input[itemprop=postal_code]').addClass('invalid')
  if( 1 > $('select[itemprop=country_code]').val().length)
    $('select[itemprop=country_code]').addClass('invalid')
