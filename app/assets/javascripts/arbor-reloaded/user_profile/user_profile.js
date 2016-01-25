$(document).ready(function(){
  $('.user-name').prop('disabled', true);
  $('.user-mail').prop('disabled', true);
});

function displayInitialWhenNoAvatar() {
  var initial = $('#user_full_name').val().trim().substring(0,1);
  $('#avatar-circle').text(initial.toUpperCase());
}

// firing update when avatar image selected, Ale
function bindUpdateOnImageSelect() {
  $("#edit-user-avatar-link").change(function () {
      $('#save-user-profile').click();
  });
}

function revealSaveCanelButtons() {
  $("#edit-user-profile-btn").click(function () {
      $('#save-user-profile').show();
      $('#cancel-btn').show();
      $('#edit-user-profile-btn').hide();

      $('.user-name').prop('disabled', false);
      $('.user-mail').prop('disabled', false);
      $('.user-name').focus();
  });
}

function hideSaveCanelButtons() {
  $("#cancel-btn").click(function () {
      $('#save-user-profile').hide();
      $('#cancel-btn').hide();
      $('#edit-user-profile-btn').show();

      $('.user-name').prop('disabled', true);
      $('.user-mail').prop('disabled', true);
  });
}
