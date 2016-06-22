// firing update when avatar image selected, Ale
function bindUpdateOnImageSelect() {
  $("#edit-user-avatar-link").change(function(){
    $('#save-user-profile').click();
  });
}

function copyArborToken() {
  $('#copy-token').click(function(){
    clipboard.copy($('#arbor-token-field').text());
    return false;
  });
}

$(document).ready(function(){
  if ($('.section-profile').length) {
    bindUpdateOnImageSelect();
    copyArborToken();
  }
});
