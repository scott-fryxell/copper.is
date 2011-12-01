// stuff that should happen on every page
$(document).ready(function() {
  $("input[name='authenticity_token']").val($('meta[name=csrf-token]').attr('content'));
  jQuery('time').timeago();
  $.get('/users/current.json', function(data) {
    current_user = data.user;
    $(document).trigger("get:current_user");
  });
});
var current_user = {};