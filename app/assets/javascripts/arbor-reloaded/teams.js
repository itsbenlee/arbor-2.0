function teamBinds() {
  if ($('.teams-list').length) {
    displayActions();
    displayHideDelete();
    // TODO When we do a delete method for more than just stories, we should re-enable this, Mojo
    toggleDeleteConfirmation();
  }
}

$( document ).ready(function() {
  teamBinds();
});
