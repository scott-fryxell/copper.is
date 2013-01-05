$(document).on "load.home_welcome", ->
  $("#banner > header > figure").css 'display','inline-block'
  
  # carousel the samples
  show_sample = (element) ->
    if 'nope' isnt $(element).attr 'data-distance' 
      $("#samples > nav > a").removeClass "selected"
      $(element).addClass "selected"
      $('#samples > figure').animate marginLeft: $(element).attr 'data-distance'
  
  
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

