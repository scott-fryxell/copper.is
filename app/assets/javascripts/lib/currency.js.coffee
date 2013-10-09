jQuery.fn.extend
  tip_amount_options: -> [5,10,25,50,75,100,200,300,500,1000,1500,2000]

  format_cents_to_dollars:  (property_name) ->
    $("*[itemprop=#{property_name}]").not('input').not('select').each ->
      cents = $(@).text().trim()
      $(@).cents_to_dollars(cents)

  cents_to_dollars: (cents) ->
    dollars = (parseFloat(cents) / 100.00).toFixed(2)
    if $(@).is('input')
      $(@).val = dollars 
    else
      $(@).text dollars 

  show_dollars: (elment) ->
    if $(element).attr 'data-cents'
      $(element).cents_to_dollars( $(@).attr('data-cents') or 0)
    else
      $(element).text 0 
