var copper = copper || {}
$(document).ready(function() {
  $.get('/users/me.json', function(data) {
    copper.me = data;
    $(document).trigger("copper:me");
  });
});
