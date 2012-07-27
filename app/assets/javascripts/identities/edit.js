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
    $(this).addClass('working');
    $('#email > form > input').removeClass("invalid");
    // submit email
    jQuery.ajax({
      url: '/users/me',
      type: 'put',
      data: $('#email > form').serialize(),
      error: function(data, textStatus, jqXHR) {
        $('#email > form > input').addClass("invalid");
        console.error("error submiting email form ", data, textStatus, jqXHR);
      }
    });

    // validate address



  });

});