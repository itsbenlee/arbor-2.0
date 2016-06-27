function copyArborToken() {
  $('#copy-token').click(function(){
    clipboard.copy($('#arbor-token-field').text());
    return false;
  });
}

$(document).ready(function(){
  if ($('.section-profile').length) {
    copyArborToken();
  }
});
