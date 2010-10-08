$(document).ready(function(event){
  $("include").each(function(link){
    $.get($(this).attr("href"), function(data){
      console.debug("retrieved", data);
    })
  })
})