function teamBinds() {
  if ($('.teams-list').length) {
    displayActions();
    displayHideDelete();
  }
}

$('#team-members-modal').on('opened.fndtn.reveal', function() {
  customScroll();
});

$( document ).ready(function() {
  teamBinds();
});
