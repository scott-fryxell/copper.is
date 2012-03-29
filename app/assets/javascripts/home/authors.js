$(document).ready(function (){
  $("#badge_template" ).template( "badge" );
  render()
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
var badge = {
  type: "name",
  color: "copper",
  size: "200",
}
function render(){
  $("#badge > aside figure > img").remove();
  $.tmpl( "badge", badge ).appendTo( "#badge > aside > figure" );
  $("#badge_text").val( $("#badge > aside > figure" ).html());
  $("#badge_text").select();
}