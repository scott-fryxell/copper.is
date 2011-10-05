var badge = {
  type: "iou",
  color: "red",
  size: "200",
}
$(document).ready(function (){

  $( "#badge_template" ).template( "badge" );
   $.tmpl( "badge", badge ).appendTo( "#badge > figure" );

  console.info("badge is running");
  $("#type").change(function (event){
    $("#badge > figure > img").remove();
    badge.type = $("#type option:selected").val();
   $.tmpl( "badge", badge ).appendTo( "#badge > figure" );
  });

  $("#color").change(function (event){
    $("#badge > figure > img").remove();
    badge.color = $("#color option:selected").val();
   $.tmpl( "badge", badge ).appendTo( "#badge > figure" );
  });

  $("#size").change(function (event){
    $("#badge > figure > img").remove();
    badge.size = $("#size option:selected").val();
   $.tmpl( "badge", badge ).appendTo( "#badge > figure" );
  });
});
