
$(document).on "load.home_badge", ->
  badge = 
    type: "name",
    size: "175",
    render: ->
      $("#badge figure > img").remove()
      $.tmpl( "badge", badge ).appendTo "#badge figure"
      $("#badge textarea").val $("#badge figure" ).html() 
      $("#badge textarea").select()

  $("#badge_template").template "badge"
  badge.render()

  $("#size").change (event) ->
    badge.size = $("#size option:selected").val()
    badge.render()

  $("#badge textarea").click ->
    $(this).select()

