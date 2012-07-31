$(document).on("copper:identities_edit", function (){
  $('#sign_in').hide();
  $('#signed_in').hide();

  $('#address > form > select').change(function (event){
    $("select[itemprop='subregion_code']").remove();

    $.get('/states?country_code=' + $(this).val(), function (data){
      $('#address > form').append(data);
    });
  });

  $('body > nav > button').click(function(event){
    $('input').removeClass("invalid");
    $('select').removeClass("invalid");
    
    // validate email
    email = $('input[itemprop=email]').val();
    if( email.search(/\./) == -1 || email.search('@') == -1 || email.indexOf('@') < 2  ){
      $('input[itemprop=email]').addClass('invalid')
    }
    if( 4 > $('input[itemprop=payable_to]').val().length){
      $('input[itemprop=payable_to]').addClass('invalid')
    }
    if( 4 > $('input[itemprop=line1]').val().length){
      $('input[itemprop=line1]').addClass('invalid')
    }
    if( 4 > $('input[itemprop=city]').val().length){
      $('input[itemprop=city]').addClass('invalid')
    }
    if( 4 > $('input[itemprop=postal_code]').val().length){
      $('input[itemprop=postal_code]').addClass('invalid')
    }
    if( 1 > $('select[itemprop=country_code]').val().length){
      $('select[itemprop=country_code]').addClass('invalid')
    }

    if($('input.invalid').size() == 0 ||  $('select.invalid').size() == 0 ) {
      $(this).addClass('working');
      jQuery.ajax({
        url: '/users/me',
        type: 'put',
        data: $('form').serialize(),
        error: function(data, textStatus, jqXHR) {
          alert('There was a problem. Please verify your address and email then try again.')
          $('#email > form > input').addClass("invalid");
          $('body > nav > button').removeClass('working')
        },
        success: function(data, textStatus, jqXHR) {
          console.debug('success')
          window.location.pathname = '/authors/me'
        }
      });
    }
  });

});