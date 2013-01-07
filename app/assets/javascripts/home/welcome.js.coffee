$(document).on "load.home_welcome", ->
  $("#banner > header > figure").css 'display','inline-block'
  scroll_to = $('#samples nav:first-child').offset().left
  $('#samples > figure').animate marginLeft: "#{scroll_to}px"

  $("#banner > header > figure img:nth-child(5)").hover ->
    $("#banner > header > figure img:nth-child(4)").toggleClass('spinning')

  # $("#samples > nav > a").click (event) ->
  #   event.preventDefault()
  #   clearInterval carousel
  #   show_sample @

  # carousel the samples
  show_sample = (nav, img) ->
    unless 'nope' is $(nav).attr 'data-distance' 
      $("#samples > nav > a").removeClass "selected"
      $("#samples > figure > img").removeClass "selected"
      $(nav).addClass "selected"
      $(img).addClass "selected"
      offset =  scroll_to - ( ($(img).outerWidth() + 30) * parseInt($(nav).attr 'data-distance'))
      $('#samples > figure').animate marginLeft: "#{offset}px"
  
  carousel = setInterval ->
    if "more" is $("#samples > nav > a.selected").next().attr('id')
      show_sample $("#samples > nav > a:first-child"), $("#samples > figure > img:first-child")
    else 
      show_sample $("#samples > nav > a.selected").next(), $("#samples > figure > img.selected").next()
  , 5000

