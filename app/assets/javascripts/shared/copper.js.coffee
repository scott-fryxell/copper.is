document.copper =
  tip_amount_options: [
                       5,10,25
                       50,75,100
                       200,300,500
                       1000,1500,2000
                      ]
  format_cents_to_dollars:  (property_name) ->
    $("*[itemprop=#{property_name}]").not('input').not('select').each ->
      cents = $(@).text().trim()
      $(@).text document.copper.cents_to_dollars(cents)
  cents_to_dollars: (cents) ->
    dollars = (parseFloat(cents) / 100.00).toFixed(2)
    return dollars

$(document).ready ->
  jQuery('time').timeago();
  $(document).trigger "load.#{$('body').attr('id')}"
  $(document).trigger(window.location.hash)
  $('[data-cents]').each ->
    if $(@).attr('data-cents')
      $(@).text( document.copper.cents_to_dollars( $(@).attr('data-cents')) or 0)
    else
      $(@).text(0)

$('body').on 'load.endless', ->
  $('[data-cents]').each ->
    if $(@).attr('data-cents')
      $(@).text( document.copper.cents_to_dollars( $(@).attr('data-cents')) or 0)
    else
      $(@).text(0)
