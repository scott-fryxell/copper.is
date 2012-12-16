$(document).on("load.identities_edit", function (){
  $('#sign_in').hide();
  $('#signed_in').hide();

  $('body > nav > button').click(function(event){

    $('#email form').trigger('item.validate')
    $('#address form').trigger('item.validate')

    if($('input.invalid').size() == 0 ||  $('select.invalid').size() == 0 ) {
      $(this).addClass('working');
      jQuery.ajax({
        url: '/fans/me',
        type: 'put',
        data: $('form').serialize(),
        error: function(data, textStatus, jqXHR) {
          alert('There was a problem. Please verify your address and email then try again.')
          $('body > nav > button').removeClass('working')
        },
        success: function(data, textStatus, jqXHR) {
          window.location.pathname = '/authors/me'
        }
      });
    }
  });

});