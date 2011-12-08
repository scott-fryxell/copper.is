var current_user = {};
$(document).ready(function() {
  $.get('/users/current.json', function(data) {
    current_user = data.user;
    $(document).trigger("get:current_user");
  });
});
