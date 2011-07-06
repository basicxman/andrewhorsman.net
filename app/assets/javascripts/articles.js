$(function() {
  if ($(".social-content")) {
    $(".social-content .google-plus").html('<g:plusone size="small" count="false"></g:plusone>');
    $("body").append('<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>');
  }
});
