
$(document).on("copper:home_show_author", function (){
  $("#badge_template" ).template( "badge" );
  badge.render()
  $("#size").change(function (event){
    badge.size = $("#size option:selected").val();
    badge.render();
  });
  $("#settings textarea").click(function (){
    $(this).select();
  });
});

var badge = {
  type: "name",
  size: "175",
  render: function (){
    $("#settings figure > img").remove();
    $.tmpl( "badge", badge ).appendTo( "#settings figure" );
    $("#settings textarea").val( $("#settings figure" ).html());
    $("#settings textarea").select();
  }
}

