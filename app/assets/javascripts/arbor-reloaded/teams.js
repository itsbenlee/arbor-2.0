function teamBinds() {
  if ($('.teams-list').length) {
    displayActions();
    displayHideDelete();
  }
}

$( document ).ready(function() {
  teamBinds();
});
