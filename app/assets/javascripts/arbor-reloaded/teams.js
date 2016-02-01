function teamBinds() {
  if ($('.teams-list').length) {
    displayActions();
    displayHideDelete();
    displayInitialWhenNoAvatarTeams();
  }
}

$('#team-members-modal').on('opened.fndtn.reveal', function() {
  customScroll();
});

$( document ).ready(function() {
  teamBinds();
});

function displayInitialWhenNoAvatarTeams() {
  var initial = $('#user_full_name').text().trim().substring(0,1);
  $('#avatar-circle').text(initial.toUpperCase());
}
