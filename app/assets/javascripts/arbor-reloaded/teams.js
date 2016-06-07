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
    removeMembers();
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

function removeMembers() {
  $('.remove-member-check').click(function() {
    if ($(this).is(':checked') && confirm('Are you sure you want to remove the member?')) {
      var url = $(this).data('url'),
          type = 'DELETE',
          currentObject = {};
      ajaxCall(url, type, currentObject);
      return false;
    }
  });
}

$(document).ready(function() {
  teamBinds();
});
