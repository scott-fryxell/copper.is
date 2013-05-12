$(document).on "load.pages_show", ->
  page = document.items['pages'][window.location.pathname]

  if $.browser.chrome
    $('#banner > figure').addClass('chrome')
  else if $.browser.mozilla
    $('#banner > figure').addClass('mozilla')
  else
    $('#banner > figure').addClass('safari')

  $("button[formaction]").click ->
    # toggle the buttons value, this way the ui doesn't have to wait. 
    value = $(@).val() 

    if value
      value = 'false'
    else
      value = 'true'

    $(@).val(value) 

    # jQuery.ajax
    #   url:$(@).attr('formaction')
    #   method:$(@).attr('formmethod')
    #   headers: {retrieve_as_data: "true"}
    #   success: (data) ->
    #     $('data#items').append(data)
    #     console.debug('bam!')
    #     new Items($('data#items'))
    #     $('data#items').empty()
    #   statusCode:
    #     401:=>
    #       $(@).trigger "401"
    #       console.debug("you don't have rights to view this resource")
