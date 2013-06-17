$(document).on "load.authors_edit load.home_settings", ->
  $('#address > form > fieldset > select').change ->
    $("select[itemprop='subregion_code']").remove()

    jQuery.get "/states?country_code=#{$(@).val()}", (data) ->
      $('#address > form > fieldset').append(data)

  $('#address > form').on "item.validate", ->
    $('#address input').removeClass("invalid")
    $('#address select').removeClass("invalid")

    if( 4 > $('input[itemprop=payable_to]').val().length)
      $('input[itemprop=payable_to]').addClass('invalid')
    if( 4 > $('input[itemprop=line1]').val().length)
      $('input[itemprop=line1]').addClass('invalid')
    if( 4 > $('input[itemprop=city]').val().length)
      $('input[itemprop=city]').addClass('invalid')
    if( 4 > $('input[itemprop=postal_code]').val().length)
      $('input[itemprop=postal_code]').addClass('invalid')
    if( !$('select[itemprop=country_code]').val())
      $('select[itemprop=country_code]').addClass('invalid')