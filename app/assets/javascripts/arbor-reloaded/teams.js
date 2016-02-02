function teamBinds() {
  if ($('.teams-list').length) {
    displayActions();
    displayHideDelete();
  }
}

$('#team-members-modal').on('opened.fndtn.reveal', function() {
  var newMemberMailTextId     = $('.new-member-mail'),
      footerButtonId          = $('#team-modal-footer-btn'),
      footerButtonInitialText = $(footerButtonId).text();

  $(newMemberMailTextId).keyup(function(e) {
    if($(this).val() === '') {
      $(footerButtonId).text(footerButtonInitialText);
    } else {
      $(footerButtonId).text('Invite');
    }
  });

  customScroll();
  bindActionsToButton();
});

function bindActionsToButton() {
  $('#team-modal-footer-btn').click(function() {
    if ($(this).text() == 'Close') {
      $('#team-members-modal').foundation('reveal', 'close');
    }
    if ($(this).text() == 'Invite') {
      $('#submit-modal-form').click();
    }
  });
}

$( document ).ready(function() {
  teamBinds();
});
