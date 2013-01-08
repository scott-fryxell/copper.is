$(document).on "items.updated.home_index", ->
  tip_preference = $("span[itemprop=tip_preference_in_cents]").attr('data-value')
  $("span[itemprop=tip_preference_in_cents]").text document.copper.cents_to_dollars(tip_preference)

$(document).on "load.home_index", ->
  if '' is $('#stats > div:nth-child(3) > p').text().trim() 
    $('#stats > div:nth-child(3)').hide()
  else
    dollars = document.copper.cents_to_dollars($('#stats > div:nth-child(3) > p').text().trim())
    $('#stats > div:nth-child(3) > p').text dollars

  $('#stats > div > p > button:nth-child(2)').click ->
    for amount in document.copper.tip_amount_options
      unless '2000' is document.copper.me.tip_preference_in_cents  
        if amount > document.copper.me.tip_preference_in_cents
          document.copper.me.tip_preference_in_cents = amount
          $('#stats > div > p > span').text document.copper.cents_to_dollars(amount)
          $(document).trigger 'save.me'
          return

  $('#stats > div > p > button:nth-child(3)').click ->
    reversed =  document.copper.tip_amount_options.reverse()
    for amount in reversed
      unless '5' is document.copper.me.tip_preference_in_cents
        if amount < document.copper.me.tip_preference_in_cents
          document.copper.me.tip_preference_in_cents = amount
          $('#stats > div > p > span').text document.copper.cents_to_dollars(amount)
          $(document).trigger 'save.me'
          return

$(document).on "load.home_index", ->




  $('#pages > details:first summary').click()
  $('#pages details[itemtype=tips] form[method=put] input[type=text]').focus()
  
  # format the page tip totals into dollars
  $('details[itemscope] > summary > figure > figcaption').each ->
    $(@).text document.copper.cents_to_dollars( $(@).text() )

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

# if logged in display the the second step in the sign up process.
$(document).on "me.home_index", ->
  if $('#facebook').size() > 0
    facebook = -1
    for identity in document.copper.me.identities 
      if identity.provider is 'facebook'
        facebook = identity

    if facebook
      likes_url = "https://graph.facebook.com/#{facebook.username}/likes?limit=9&access_token=#{facebook.token}"
      me_url = "https://graph.facebook.com/me?&access_token=#{facebook.token}"

      $.getJSON(likes_url).success (facebook) ->
        $.each facebook.data, (i, a_like) ->
          $.getJSON("https://graph.facebook.com/#{a_like.id}").success (like) ->
            image = $('<img/>', src:"https://graph.facebook.com/#{like.id}/picture")
            $('<a/>', {href:like.link, html:image}).appendTo('#facebook > nav')

   