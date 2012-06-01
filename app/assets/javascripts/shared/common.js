$(document).ready(function() {
  $("input[name='authenticity_token']").val($('meta[name=csrf-token]').attr('content'));
  jQuery('time').timeago();
});
