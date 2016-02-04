function teamBinds() {
  if ($('.teams-list').length) {
    displayActions();
    displayHideDelete();
    teamMembersBind();
  }
}

function teamMembersBind() {
  $('#team-members-modal').on('opened.fndtn.reveal', function() {
    footerButtonId  = $('.team-members-button'),
    teamMemberEmail = $('.team-member-email');

    teamMemberEmail.keyup(function(e) {
      if($(this).val() === '') {
        footerButtonId.text('Close');
      } else {
        footerButtonId.text('Invite');
      }
    });

    customScroll();
    bindActionsToButton();
  });
}

function bindActionsToButton() {
  $('.team-members-button').click(function() {
    if ($(this).text() == 'Close') {
      $('#team-members-modal').foundation('reveal', 'close');
    }
    if ($(this).text() == 'Invite') {
      $('.new-member').submit();
    }
  });
}

$(document).ready(function() {
  teamBinds();
});
