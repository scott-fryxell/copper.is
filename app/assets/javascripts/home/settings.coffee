$(document).on "load.home_settings", ->

  $("section.setting > header > a").click (event) ->
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
      # console.debug('show the credit card form')
      $("#card > header > a").click()
    ,1000)

  $('p[itemprop=tip_preference_in_cents]').on 'item.changed', ->
    $(@).cents_to_dollars($(@).text().trim())

  $("#rate form").on 'item.validate', ->
    $('#rate p[itemprop=tip_preference_in_cents]').cents_to_dollars $('select[itemprop=tip_preference_in_cents]').val()

$(document).on "me.home_settings", ->
  $("#rate > form > select > option[value=#{document.me.tip_preference_in_cents}]").attr 'selected', true

  $("#email > header > a").click() unless document.me.email

  if document.me.stripe_id
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
