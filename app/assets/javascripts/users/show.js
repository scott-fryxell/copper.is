$(document).on("items.updated.users_show", function (event){
  // console.debug("items.updated.users_show");
  copper.format_cents_to_dollars("tip_preference_in_cents");
});

$(document).on("load.users_show", function (event){
  $('#tips details').first().attr('open','open')
  // console.debug("load.users_show")
  copper.format_cents_to_dollars("amount_in_cents")

  $("input[itemprop=amount_in_cents]").each(function (){
    var formated_amount = copper.cents_to_dollars($(this).val());
    $(this).val(formated_amount);
  });

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
        $(document).trigger('save.me')
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
        $(document).trigger('save.me')
        return
      }
    }
  });

});

// key commands for showing unimplemented features
$(document).on("load.users_show", function (event){
  // todo remove when features are completed.
  var isCtrl = false;
  $(document).keyup(function (e){
    if(e.which == 17){
      isCtrl=false;
    }
  }).keydown(function (e){
    if(e.which == 17){
      isCtrl=true;
    }
    if(e.which == 68 && isCtrl == true){
      $('#tips > header > nav').toggle(1000)
      return false;
    }
  });
});

// remove items when tip is cancelled
$(document).on("load.users_show", function (event){
  $('*[itemtype=tips]  form[method=delete]').on('item.delete', function(){
    var tip = $(this).parents('*[itemscoped]')[0]
    var page = $(this).parents('*[itemscoped]')[1]
    $(tip).remove()

    tip_count = $(page).find('tbody > tr').size() 

    if (0 == tip_count){
      $(page).remove();
    }
    else if(1 == tip_count){
      $(page).find('dl > dt > details > summary').text('1 Tip')
    }
    else{
      $(page).find('dl > dt > details > summary').text(tip_count + ' Tips')
    }
    // TODO update the pages tip totals
    var new_total = 0;
    $(page).find('input[itemprop=amount_in_cents]').each(function(){
      new_total = new_total + Number($(this).val());
    });

    $(page).find('figcaption[itemprop=amount_in_cents]').text(new_total);
  });

  $('*[itemtype=tips]  form[method=post]').on('item.post', function(){
    var page = $(this).parents('*[itemscoped]')[1]
    // TODO update the pages tip totals
    var new_total = 0;
    $(page).find('input[itemprop=amount_in_cents]').each(function(){
      new_total = new_total + Number($(this).val());
    });

    $(page).find('figcaption[itemprop=amount_in_cents]').text(new_total);
  });

});