$(document).on "load.home_index", ->
  # set up page stats.
  $('span[itemprop=tip_preference_in_cents]').on 'item.changed', ->
    $(@).text document.copper.cents_to_dollars($(@).text().trim())

  if '' is $('#stats > div:nth-child(3) > p').attr('data-cents').trim() 
    $('#stats > div:nth-child(3)').hide()

  $('#stats > div > p > button:nth-child(2)').click ->
    for amount in document.copper.tip_amount_options
      unless 2000 is document.copper.me.tip_preference_in_cents  
        if amount > document.copper.me.tip_preference_in_cents
          document.copper.me.tip_preference_in_cents = amount
          $('#stats > div > p > span').text document.copper.cents_to_dollars(amount)
          $(document).trigger 'save.me'
          return

  $('#stats > div > p > button:nth-child(3)').click ->
    reversed = document.copper.tip_amount_options.slice(0).reverse()
    for amount in reversed
      unless 5 is document.copper.me.tip_preference_in_cents
        if amount < document.copper.me.tip_preference_in_cents
          document.copper.me.tip_preference_in_cents = amount
          $('#stats > div > p > span').text document.copper.cents_to_dollars(amount)
          $(document).trigger 'save.me'
          return

$(document).on "load.home_index", ->

  # format tips into dollars
  $("*[itemtype=tips] input[type=text]").each -> 
    $(@).val document.copper.cents_to_dollars($(@).val())

  $("*[itemtype=tips] span[itemprop=amount_in_cents]").each -> 
    $(@).text document.copper.cents_to_dollars($(@).text())

  $("*[itemtype=tips] form[method=delete]").on 'item.delete', ->
    tip = $(@).parents('*[itemscope]')[0]
    page = $(@).parents('*[itemscope]')[1]
    $(tip).remove()

    tip_count = $(page).find('tbody > tr').size()

    if 0 is tip_count
      $(page).remove()
    else if 1 is tip_count
      $(page).find('dl > dt > details > summary').text '1 Tip'
    else
      $(page).find('dl > dt > details > summary').text "#{tip_count} Tips"
    
    # TODO update the pages tip totals
    new_total = 0;
    $(page).find('input[itemprop=amount_in_cents]').each ->
      new_total = new_total + Number($(@).val())
    $(page).find('figcaption').text document.copper.cents_to_dollars(new_total) 

  $('*[itemtype=tips] form[method=put]').on 'item.validate', ->
    tip_amount_in_cents = (parseFloat($(@).find('input[type=text]').val()) * 100);
    $(@).find('input[itemprop=amount_in_cents]').val tip_amount_in_cents

  # TODO update the pages tip totals
  $('*[itemtype=tips] form[method=put]').on 'item.put', ->
    page = $(@).parents('*[itemscope]')[1]
    new_total = 0
    $(page).find('input[type=text]').each -> new_total += Number($(@).val())
    $(page).find('span[itemprop=amount_in_cents]').each -> new_total +=  Number($(@).text())
    $(page).find('figcaption').text new_total

  $(document).on '#latest_tip', ->
    $('#pages > details:nth-child(2) > summary').click()
