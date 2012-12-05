$(document).on("items.updated.users_show", function (event){
  copper.format_cents_to_dollars("tip_preference_in_cents")

});

$(document).on("load.users_show", function (event){
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

  $("#tips > aside > nav > a:nth-child(3)").click(function(){
    $('#tips > aside').trigger("delete.current_tip");
  });

  $('#tips > ol > li').click(function (event){
    $(this).trigger('focus.tip')
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
      $('#tips > aside > nav > a:first-child').toggle(1000)
      $('#tips > aside > dl > dt:first-child').toggle(1000)
      $('#tips > aside > dl > dd:nth-child(2)').toggle(1000)
      $('#tips > aside > footer > nav').toggle(1000)
      return false;
    }
  });
});
// show tip in main area when tip is clicked
$(document).on("load.users_show", function (event){
  $('#tips > ol > li').bind('focus.tip', function(){
    var li = this;
    $('li.selected').removeClass('selected');
    $(li).addClass('selected');
    $('#tips > aside').animate({opacity:0}, 500, function(){
      $('#tips > aside > h2').text($(li).attr('data-title'))
      $("#tips > aside > figure > img").attr("src", $(li).find('img').attr('src'))
      $("#tips > aside > figure > figcaption").text($(li).attr('data-amount'))
      $("#tips > aside > nav > a[target=_blank]").attr('href', $(li).attr('data-url'))
      $('#tips > aside > dl > dd:nth-child(4)').text($(li).attr('data-site'))
      $('#tips > aside > dl > dd:nth-child(6)').text($(li).attr('data-paid_state'))
      $("#tips > aside > footer > time").remove()
      $('#tips > aside').attr('itemid', $(li).attr('itemid'))
      $('<time/>', {
        datetime: $(li).attr('data-created_at')
      }).appendTo("#tips > aside > footer")
      
      $("#tips > aside > footer > time").timeago();
      copper.format_cents_to_dollars("amount_in_cents")
      $(this).animate({opacity:1},400)
    });
  });
});

// remove items when tip is cancelled
$(document).on("load.users_show", function (event){
  $(document).bind('delete.current_tip', function(event){
    var deleted_tip = $('#tips > aside').attr('itemid');
    li = $('li[itemid="' + deleted_tip + '"]').fadeOut(1000, function(){
      $(this).remove()
    });
    next_tip = $(li).next();
    jQuery.ajax({
      url: deleted_tip,
      type: 'delete',
      success: function (data, textStatus, jqXHR){
        if(next_tip.size() == 0){
          $('#tips > ol > li:first-child').click()
        }else{
          $(next_tip).click();
        }
      },
      error: function (data, textStatus, jqXHR) {
        alert('There was a problem canceling this tip, please try again later')
      }
    });
  });
});