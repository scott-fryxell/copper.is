$(document).on("items.updated.users_show", function (event){
  var tip_preference = $("span[itemprop=tip_preference_in_cents]").attr('data-value');
  $("span[itemprop=tip_preference_in_cents]").text(copper.cents_to_dollars(tip_preference));
});

// manage the stats for this fan
$(document).on("load.users_show", function (event){

  if( '' == $('#stats > div:nth-child(3) > p').text().trim() ){
    $('#stats > div:nth-child(3)').hide()
  } else {
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

// Manage all the users pages
$(document).on("load.users_show", function (event){

  $('#pages > details:first summary').click();
  
  $('#pages details[itemtype=tips] form[method=put] input[type=text]').focus();
  // format the page tip totals into dollars
  $('details[itemscope] > summary > figure > figcaption').each(function(){
    $(this).text(copper.cents_to_dollars($(this).text()));
  });

  // format tips into dollars
  $("input[type=text]").each(function (){
    $(this).val(copper.cents_to_dollars($(this).val()));
  });

  $("*[itemtype=tips] span[itemprop=amount_in_cents]").each(function (){
    $(this).text(copper.cents_to_dollars($(this).text()));
  });

  $('*[itemtype=tips] form[method=delete]').on('item.delete', function(){
    var tip = $(this).parents('*[itemscope]')[0]
    var page = $(this).parents('*[itemscope]')[1]
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

  $('*[itemtype=tips] form[method=put]').on('item.validate', function(){
    var tip_amount_in_cents = (parseFloat($(this).find('input[type=text]').val()) * 100);
    $(this).find('input[itemprop=amount_in_cents]').val(tip_amount_in_cents);
  });

  $('*[itemtype=tips] form[method=put]').on('item.put', function(){
    var page = $(this).parents('*[itemscope]')[1]
    // TODO update the pages tip totals
    var new_total = 0;
    $(page).find('input[type=text]').each(function(){
      new_total = new_total + Number($(this).val());
    });

    $(page).find('span[itemprop=amount_in_cents]').each(function(){
      new_total = new_total + Number($(this).text());
    });
    $(page).find('figcaption').text(new_total);
  });
});
