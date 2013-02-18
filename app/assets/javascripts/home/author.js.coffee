$(document).on "load.home_author", ->

  $('*[data-cents]').each ->
    $(@).text( document.copper.cents_to_dollars( $(@).attr('data-cents')) or 0)

  badge = 
    type: "name",
    size: "175",
    render: ->
      $("#settings figure > img").remove()
      $.tmpl( "badge", badge ).appendTo "#settings figure"
      $("#settings textarea").val $("#settings figure" ).html() 
      $("#settings textarea").select()

  $("#badge_template").template "badge"
  badge.render()

  $("#size").change (event) ->
    badge.size = $("#size option:selected").val()
    badge.render()

  $("#settings textarea").click ->
    $(this).select()
    
  $('#authors > aside > nav > a > img, #authors form > input').click ->
    $(@).addClass 'working'

  $("#authors form").on 'item.delete', ->
    $(@).parent().remove()
    if 2 > $("#authors form").size()
      $('#authors figure > form').addClass 'hide'
