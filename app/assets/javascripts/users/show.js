$(document).on("copper:users_show", function (event){
  copper.format_cents_to_dollars("tip_preference_in_cents")
  copper.format_cents_to_dollars("amount_in_cents")
  if( '' == $('#stats > div:nth-child(3) > p').text().trim()){
    
    $('#stats > div:nth-child(3)').hide()
  }else{
    var dollars = copper.cents_to_dollars($('#stats > div:nth-child(3) > p').text().trim());
    $('#stats > div:nth-child(3) > p').text(dollars)
  }

  $('#stats > div > p > button:nth-child(2)').click(function (){
    for (var i=0; i < copper.tip_amount_options.length; i++) {
      if('2000' == copper.me.tip_preference_in_cents){
        return;
      }
      if( copper.tip_amount_options[i] == copper.me.tip_preference_in_cents){
        var new_tip = copper.tip_amount_options[i+1]
        copper.me.tip_preference_in_cents = new_tip
        $('#stats > div > p > span').text(copper.cents_to_dollars(new_tip))
        $(document).trigger('copper.save_me')
        return
      }
    }
  });

  $('#stats > div > p > button:nth-child(3)').click(function (){
    for (var i=0; i < copper.tip_amount_options.length; i++) {
      if('5' == copper.me.tip_preference_in_cents){
        return
      }
      if( copper.tip_amount_options[i] == copper.me.tip_preference_in_cents){
        var new_tip = copper.tip_amount_options[i-1]
        copper.me.tip_preference_in_cents = new_tip
        $('#stats > div > p > span').text(copper.cents_to_dollars(new_tip))
        $(document).trigger('copper.save_me')
        return
      }
    }
  });

  $("#tips > aside > nav > a:nth-child(3)").click(function(){
    console.debug($(this).parent().parent().attr('itemid'))

    jQuery.ajax({
      url: $(this).parent().parent().attr('itemid'),
      type: 'delete',
      success: function (data, textStatus, jqXHR){
        console.debug('current tip deleted')
        $('#tips > aside').trigger("copper.cancel_current_tip");
        window.location.reload();
      },
      error: function (data, textStatus, jqXHR) {
        alert('There was a problem canceling this tip, please try again later')
      }
    });
  })

});

$(document).bind('copper.cancel_current_tip', function(event){
  console.debug('delete current tip')
});
