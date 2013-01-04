$(document).on "items.updated.home_index", ->
  tip_preference = $("span[itemprop=tip_preference_in_cents]").attr('data-value')
  $("span[itemprop=tip_preference_in_cents]").text document.copper.cents_to_dollars(tip_preference)

$(document).on "load.home_index", ->

  # set appropriate extension based on browswer type
  is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1
  if is_chrome
    $("a.install").click ->
      url = "https://chrome.google.com/webstore/detail/aoioappfaobhjafcnnajbndogjhaodpb"
      chrome.webstore.install url, ->
       $(document).trigger 'copper.button_installed'
      , (event) ->
        console.error 'not working', event 
        alert event

  else if $.browser.safari 
    $("a.install").click ->
      $(@).attr "href", "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.safariextz"
      $(document).trigger 'copper.button_installed'

  else if $.browser.mozilla
    $("a.install").click ->
      params = 
        "Foo": 
          URL: "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi?"
          IconURL: "/assets/icons/logo.svg"
          Hash: "sha1:8e169c7ec8d5c2f21e5c6e2d1d173bedc001fe35"
          toString: -> "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi"
      InstallTrigger.install params
      $(document).trigger 'copper.button_installed'
      false;
  else
    $("a.install").hide();

  if '' is $('#stats > div:nth-child(3) > p').text().trim() 
    $('#stats > div:nth-child(3)').hide()
  else
    dollars = document.copper.cents_to_dollars($('#stats > div:nth-child(3) > p').text().trim())
    $('#stats > div:nth-child(3) > p').text dollars

  $('#stats > div > p > button:nth-child(2)').click ->
    for amount in document.copper.tip_amount_options
      unless '2000' is document.copper.me.tip_preference_in_cents  
        if amount is document.copper.me.tip_preference_in_cents
          copper.me.tip_preference_in_cents = amount
          $('#stats > div > p > span').text document.copper.cents_to_dollars(amount)
          $(document).trigger 'save.me'
          return

  $('#stats > div > p > button:nth-child(3)').click ->
    for amount in document.copper.tip_amount_options
      unless '5' is document.copper.me.tip_preference_in_cents
        if amount is document.copper.me.tip_preference_in_cents
          document.copper.me.tip_preference_in_cents = amount
          $('#stats > div > p > span').text document.copper.cents_to_dollars(amount)
          $(document).trigger 'save.me'
          return

  $('#pages > details:first summary').click()
  $('#pages details[itemtype=tips] form[method=put] input[type=text]').focus()
  
  # format the page tip totals into dollars
  $('details[itemscope] > summary > figure > figcaption').each ->
    $(@).text document.copper.cents_to_dollars( $(@).text() )

  # format tips into dollars
  $("input[type=text]").each -> 
    $(@).val document.copper.cents_to_dollars($(@).val())

  $("*[itemtype=tips] span[itemprop=amount_in_cents]").each -> 
    $(@).text document.copper.cents_to_dollars($(@).text())

  $('*[itemtype=tips] form[method=delete]').on 'item.delete', ->
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
    $(page).find('figcaption[itemprop=amount_in_cents]').text new_total 

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
