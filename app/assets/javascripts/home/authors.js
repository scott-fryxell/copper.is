var badge = {
  type: "name",
  color: "red",
  size: "200",
}
function render(){
  $("#badge > figure > img").remove();
  $.tmpl( "badge", badge ).appendTo( "#badge > figure" );
  $("#badge_text").val( $("#badge > figure" ).html());
  $("#badge_text").select();
}
$(document).ready(function (){

  $("#badge_template" ).template( "badge" );
  render()
  console.info("badge is running");
  $("#type").change(function (event){
    badge.type = $("#type option:selected").val();
    render();
  });

  $("#color").change(function (event){
    badge.color = $("#color option:selected").val();
    render();
  });

  $("#size").change(function (event){
    badge.size = $("#size option:selected").val();
    render();
  });

  $("#badge_text").click(function (){
    $(this).select();
  });
});


