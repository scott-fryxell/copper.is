$.get('/users/current.json', function(data) {
  current_user = data.user;
  $(document).trigger("get:current_user");
});
var current_user = {};