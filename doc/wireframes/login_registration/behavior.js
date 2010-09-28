$(document).ready(function() {
 $("#registered_no").change(function() {
   $('form').addClass("register");
   $("input[type=submit]").attr("value","Create Account");
 });
 $("#registered_yes").change(function() {
   $('form').removeClass("register");
   $("input[type=submit]").attr("value","Sign in");
 });
});