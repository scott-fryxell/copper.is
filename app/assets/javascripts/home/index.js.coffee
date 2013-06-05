$(document).on "load.home_index", ->
  # set up page stats.
  $('span[itemprop=tip_preference_in_cents]').on 'item.changed', ->
    $(@).text document.copper.cents_to_dollars($(@).text().trim())

  if '' is $('#stats > div:nth-child(3) > p').attr('data-cents').trim() 
    $('#stats > div:nth-child(3)').hide()

  $('#stats > div > p > img:nth-child(2)').click ->
    for amount in document.copper.tip_amount_options
      unless 2000 is document.me.tip_preference_in_cents  
        if amount > document.me.tip_preference_in_cents
          document.me.tip_preference_in_cents = amount
          $('#stats > div > p > span').text document.copper.cents_to_dollars(amount)
          Me.save()
          return

  $('#stats > div > p > img:nth-child(3)').click ->
    reversed = document.copper.tip_amount_options.slice(0).reverse()
    for amount in reversed
      unless 5 is document.me.tip_preference_in_cents
        if amount < document.me.tip_preference_in_cents
          document.me.tip_preference_in_cents = amount
          $('#stats > div > p > span').text document.copper.cents_to_dollars(amount)
          Me.save()
          return
  $(document).on '#latest_tip', ->
    $('#pages > details:nth-child(2) > summary').click()

$(document).on "me.home_index", ->
  mixpanel.track('View profile')


  