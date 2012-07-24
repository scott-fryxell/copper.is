$(document).on("copper:identities_edit", function (){
  $('#address > form > select').change(function (event){
    $("select[itemprop='subregion_code']").remove();

    $.get('/states?country_code=' + $(this).val(), function (data){
      $('#address > form').append(data);
    });
  });
});