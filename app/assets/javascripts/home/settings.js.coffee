$(document).on "load.home_settings", ->

  $("section.setting > header > a").click (event) ->
    console.debug('clicked');
    event.preventDefault();
    div = $(@).parents("section").find "div"
    form = $(@).parents("section").find "form"
    $(@).animate {opacity:0}, 200
    div.animate {opacity:0}, 500, ->
      div.css "display", "none"
      form.css "display", "inline-block"
      form.animate {opacity:1}, 500

  $("section.setting > form").submit (event) ->
    event.preventDefault();
    div = $(@).parents("section").find "div"
    $(@).animate {opacity:0},500, ->
      $(@).css "display", "none"
      $(@).parents("section").find("header > a").animate {opacity:1}, 200
      div.css "display","inline-block"
      div.animate {opacity:1}, 500

  $('#sharing > form > input').change ->  
    $('#sharing > form').submit()

  $('#sharing > form').on 'item.put', ->
    # when the user decides to post to their timeline 
    # authorize them with facebook to get permissions
    # after you have the permissions then change the 
    # checkbox
    if $('#sharing > form > input[itemprop]').attr('checked')
      window.location = '/auth/facebook/publish_actions'

  $("#card").on "bad_credit_card", ->
    credit_card_form = window.setTimeout( ->
      console.debug('show the credit card form')
      $("#card > header > a").click()
    ,1000)

  $('p[itemprop=tip_preference_in_cents]').on 'item.changed', ->
    $(@).text document.copper.cents_to_dollars($(@).text().trim())

  $("#rate form").on 'item.validate', ->
    rate = document.copper.cents_to_dollars $('select[itemprop=tip_preference_in_cents]').val()
    $('#rate p[itemprop=tip_preference_in_cents]').text rate

  $("#address form").on 'item.validate', ->
    if $('#address form .invalid').size == 0
      $('p[itemprop=payable_to]').text $(@).find('input[itemprop=payable_to]').val()
      $('p[itemprop=line1]').text $(@).find('input[itemprop=line1]').val()
      $('p[itemprop=line2]').text $(@).find('input[itemprop=line2]').val()
      $('span[itemprop=city]').text $(@).find('input[itemprop=city]').val()
      $('span[itemprop=subregion_code]').text $(@).find('select[itemprop=subregion_code]').val()
      $('span[itemprop=postal_code]').text $(@).find('input[itemprop=postal_code]').val()
    else
      $("#address > header > a").click()
        
$(document).on "me.home_settings", ->

  user = document.getItems()['users'][0]
  $("#rate > form > select > option[value=#{user.tip_preference_in_cents}]").attr 'selected', true

  if document.copper.me.country_code
    $("select[itemprop=country_code]").change()
  else
    $("#address > header > a").click()
  
  $("#email > header > a").click() unless document.copper.me.email

  if document.copper.me.stripe_id
    jQuery.ajax
      url: '/cards'
      type: 'get'
      success:  (data) ->
        $("#card p.type").text data.active_card.type
        $("#card p.number").text data.active_card.last4
        $("#card p.expiration").text "#{data.active_card.exp_month}/#{data.active_card.exp_year}"
        $("#card > div").css 'display', 'inline-block'
      error: (data, textStatus, jqXHR) ->
        console.error "error getting stripe info", data, textStatus, jqXHR ;
  else
    $("#card").trigger "bad_credit_card"