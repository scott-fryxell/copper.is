$(document).on "load.home_author", ->

  $('*[data-cents]').each ->
    $(@).text( document.copper.cents_to_dollars( $(@).attr('data-cents')) or 0)
    
  $('#authors > aside > nav > a > img, #authors form > input').click ->
    $(@).addClass 'working'

  $("#authors form").on 'item.delete', ->
    $(@).parent().remove()
    if 2 > $("#authors form").size()
      $('#authors figure > form').addClass 'hide'

$('#facebook_pages > form').submit ->
  console.debug('claiming pages');
  $(@).find('input[type=submit]').attr('disabled', 'disabled')

  jQuery.ajax
    url: $(@).attr('action')
    type: $(@).attr('method')
    data: $(@).serialize()
    error: (data, textStatus, jqXHR) ->
    success: (data, textStatus, jqXHR) ->
      window.location = '/author'

$(document).on '#claim_pages', ->

  $(document).on "me.home_author", ->
    $("#facebook_pages").css("display", "block")
    $("#facebook_pages").addClass("show")
    for author in document.copper.me.authors 
      if author.provider is 'facebook' and author.token 
        facebook = author

    if facebook
      accounts_url = "https://graph.facebook.com/me/accounts?&access_token=#{facebook.token}"
      $.getJSON(accounts_url).success (accounts) ->
        $.each accounts.data, (i, page) ->
          unless(page.category == 'Application')
            $('<input/>', {type:"checkbox", value:page.id, name:"facebook_objects[]", id:page.name}).appendTo('#facebook_pages > form > fieldset')
            $('<label/>', {html:page.name, for:page.name}).appendTo('#facebook_pages > form > fieldset')