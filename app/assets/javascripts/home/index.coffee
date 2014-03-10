$(document).on "load.home_index", ->
  # set up page stats.
  $('span[itemprop=tip_preference_in_cents]').on 'item.changed', ->
    $(@).cents_to_dollars($(@).attr('data-value'))

  if document.me.tip_count is 0
    $('#stats > div:nth-child(3)').hide()

  $('#stats img.increase').click ->
    for amount in jQuery.tip_amount_options
      unless 2000 is document.me.tip_preference_in_cents
        if amount > document.me.tip_preference_in_cents
          document.me.tip_preference_in_cents = amount
          $('#stats > div > p > span').attr('data-value', amount)
          $('#stats > div > p > span').cents_to_dollars(amount)
          $('#stats > div > p > span').change()
          return

  $('#stats img.decrease').click ->
    reversed = jQuery.tip_amount_options.slice(0).reverse()
    for amount in reversed
      unless 5 is document.me.tip_preference_in_cents
        if amount < document.me.tip_preference_in_cents
          document.me.tip_preference_in_cents = amount
          $('#stats > div > p > span').attr('data-value', amount)
          $('#stats > div > p > span').cents_to_dollars(amount)
          $('#stats > div > p > span').change()
          return

  $(document).on '#latest_tip', ->
    $('#pages > details:first-of-type > summary').click()

$(document).on "me.home_index", ->
  # mixpanel.track('View profile')
