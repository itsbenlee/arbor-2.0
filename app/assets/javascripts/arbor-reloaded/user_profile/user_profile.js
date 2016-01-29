// Hashtables, formed by [element_id, default_disabled_state/default_visible_state], Ale
var interactiveTextFields = new HashTable({
      '.user-name#user_full_name': true,
      '.user-mail#user_email': true
  }),
    interactiveButtons = new HashTable({
      '#edit-user-profile-btn': true,
      '#save-user-profile': false,
      '#cancel-btn': false
  });


$(document).ready(function(){
  if ($('.section-profile').length) {
    //first we set te default state, Ale
    setDisabledState(interactiveTextFields, false);
    setVisibleState(interactiveButtons, false);

    displayInitialWhenNoAvatar();
    bindUpdateOnImageSelect();
  }
});

function displayInitialWhenNoAvatar() {
  var initial = $('#user_full_name').val().trim().substring(0,1);
  $('#avatar-circle').text(initial.toUpperCase());
}

// firing update when avatar image selected, Ale
function bindUpdateOnImageSelect() {
  $("#edit-user-avatar-link").change(function(){
    $('#save-user-profile').click();
  });
}

$("#edit-user-profile-btn").click(function(){
  setVisibleState(interactiveButtons, true);
  setDisabledState(interactiveTextFields, true);
  $('.user-name#user_full_name').focus();
});

$("#cancel-btn").click(function(){
  setVisibleState(interactiveButtons, false);
  setDisabledState(interactiveTextFields, false);
});