$(document).on "load.home_welcome", ->
  $("#banner > header > figure").css 'display','inline-block'
  
  # carousel the samples
  show_sample = (element) ->
    if 'nope' isnt $(element).attr 'data-distance' 
      $("#samples > nav > a").removeClass "selected"
      $(element).addClass "selected"
      $('#samples > figure').animate marginLeft: $(element).attr 'data-distance'
  
  $(document).on 'copper.button_installed', ->
    $('#join').delay(0).fadeOut 800 
    $('#congrats').delay(800).fadeIn 800
    $('#facebook').delay(800).fadeIn 800
    $('#settings').delay(800).fadeIn 800, ->
      $('#settings').delay(800).css "display",'block'
  
  $("#samples > nav > a").click (event) ->
    event.preventDefault()
    clearInterval carousel
    show_sample @

  carousel = setInterval ->
    if "more" is $("#samples > nav > a.selected").next().attr('id')
      show_sample $("#samples > nav > a:first-child")
    else 
      show_sample $("#samples > nav > a.selected").next()
  , 10000

# if logged in display the the second step in the sign up process.
$(document).on "me.home_welcome", ->
  $('#join figure.step_one').hide()
  $('#join figure.step_two').show()

  facebook = -1
  for i of document.copper.me.identities 
    if document.copper.me.identities[i].provider is 'facebook'
      facebook = document.copper.me.identities[i]

  if facebook
    likes_url = "https://graph.facebook.com/#{facebook.username}/likes?limit=10&access_token=#{facebook.token}"
    me_url = "https://graph.facebook.com/me?&access_token=#{facebook.token}"

    $.getJSON(likes_url).success (facebook) ->
      $.each facebook.data, (i, a_like) ->
        $.getJSON("https://graph.facebook.com/#{a_like.id}").success (like) ->
          image = $('<img/>', src:"https://graph.facebook.com/#{like.id}/picture")
          $('<a/>', {href:like.link, html:image}).appendTo('#facebook > nav')

    $.getJSON(me_url).success (me) -> $('figure.step_two > h5 > p').append "Welcome, #{me.first_name}!"



