// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//= require jquery
//= require jquery.cookie
//= require jquery.timeago
//= require jquery.tmpl
//= require resource
//= require analytics
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