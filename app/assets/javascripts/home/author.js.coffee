$(document).on "load.home_author", ->
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