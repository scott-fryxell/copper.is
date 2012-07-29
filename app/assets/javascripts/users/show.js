$(document).on("copper:users_show", function (event){
  copper.format_cents_to_dollars("tip_preference_in_cents")
  var dollars = copper.cents_to_dollars($('#stats > div:nth-child(3) > p').text().trim() );
  $('#stats > div:nth-child(3) > p').text(dollars)

});
