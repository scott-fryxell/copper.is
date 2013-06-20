$(document).on "load.home_index load.home_author #orders_index", ->
  $("[itemtype=tips] span[itemprop=amount_in_cents]").each ->
    $(@).text document.copper.cents_to_dollars($(@).attr('data-value'))

$(document).on "load.home_index #orders_index", ->
  # format tips into dollars
  $("[itemtype=tips] input[type=text]").each ->
    $(@).val document.copper.cents_to_dollars($(@).val())

  $("[itemtype=tips] form[method=delete]").on 'item.delete', ->
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
    $(page).find('figcaption > p').text document.copper.cents_to_dollars(new_total)

  $('[itemtype=tips] form[method=put]').on 'item.validate', ->
    tip_amount_in_cents = (parseFloat($(@).find('input[type=text]').val()) * 100);
    $(@).find('input[itemprop=amount_in_cents]').val tip_amount_in_cents

  # TODO update the pages tip totals
  $('[itemtype=tips] form[method=put]').on 'item.put', ->
    page = $(@).parents('*[itemscope]')[1]
    new_total = 0
    $(page).find('input[type=text]').each -> new_total += Number($(@).val())
    $(page).find('span[itemprop=amount_in_cents]').each -> new_total +=  Number($(@).text())
    $(page).find('figcaption').text new_total
