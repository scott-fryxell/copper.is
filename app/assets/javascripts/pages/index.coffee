$(document).on "load.pages_index", ->
  $('body').addClass('manual')

  $('img.admin').click ->
    $('section.admin').toggleClass('hide')
  $("details.admin > nav > a").click ->
    $('body').toggleClass($(@).text())

  $('body').on 'change', "input[itemprop=thumbnail_url]", ->
    # console.debug($(@).parents('[itemscope]').find('img[itemprop=thumbnail_url]'))
    $(@).parents('[itemscope]').find('img[itemprop=thumbnail_url]').attr('src', $(@).val())

  $("button[formaction]").click ->
    value = $(@).attr('value')

    if value == 'true'
      new_value = 'false'
    else
      new_value = 'true'

    $(@).attr('value', new_value)
    prop = {}
    prop[$(@).attr('itemprop')] = new_value
    jQuery.ajax
      url:$(@).attr('formaction')
      method:$(@).attr('formmethod')
      headers: {retrieve_as_data: "true"}
      data: prop
      success: (data) ->
        $('data#items').append(data)
        # console.debug('bam!')
        new Items($('data#items'))
        $('data#items').empty()
      statusCode:
        401:=>
          $(@).trigger "401"
          # console.debug("you don't have rights to view this resource")

