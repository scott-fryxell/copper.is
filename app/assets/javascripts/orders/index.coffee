$(document).on "load.orders_index", ->
  $('*[itemtype=tip] form').each ->
    cents = $(@).find("input[itemprop=amount_in_cents]").attr('value')
    $(@).find("input[itemprop=amount_in_dollars]").cents_to_dollars(cents)


  # format tips into dollars
  $("*[itemtype=tip] input[type=text]").each ->
    $(@).cents_to_dollars($(@).val())

  $("*[itemtype=tip] form[method=delete]").on 'item.delete', ->
    tip = $(@).parents('*[itemscope]')[0]
    order = $(@).parents('*[itemscope]')[1]
    $(tip).remove()

    tip_count = $(order).find('#tips tbody > tr').size()

    if 0 is tip_count
      $(order).find('section > header > h2').text '1 Tip'
    else if 1 is tip_count
      $(order).find('section > header > h2').text '1 Tip'
    else
      $(order).find('section > header > h2').text "#{tip_count} Tips"

    # TODO update the pages tip totals
    new_total = 0;
    $(order).find('input[itemprop=amount_in_cents]').each ->
      new_total = new_total + Number($(@).val())
    $(order).find('section > header > h4 > span').cents_to_dollars(new_total)

  $('*[itemtype=tip] form[method=put]').on 'item.validate', ->
    tip_amount_in_cents = (parseFloat($(@).find('input[type=text]').val()) * 100);
    $(@).find('input[itemprop=amount_in_cents]').val tip_amount_in_cents

  # TODO update the pages tip totals
  $('*[itemtype=tip] form[method=put]').on 'item.put', ->
    order = $(@).parents('*[itemscope]')[1]
    new_total = 0
    $(order).find('input[type=text]').each -> new_total += Number($(@).val())
    $(order).find('span[itemprop=amount_in_cents]').each -> new_total +=  Number($(@).text())
    $(order).find('figcaption').text new_total
