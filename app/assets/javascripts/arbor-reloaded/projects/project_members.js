// functions needed on the modal view, Ale
var footerButtonInitialText = '';
$('#project-members-modal').on('opened.fndtn.reveal', function() {
  var showEditProject   = $('#show_edit_project'),
      projectDataModal  = $('.project-members'),
      editProjectForm   = $('.modal-edit-project-form'),
      footerButtonId = $('#people-modal-footer-btn');
      newMemberMailTextId = $('.new-member-mail'),
      removeMemberCheck = $('.remove-member-check'),
      removeMemberFromProjectLink = $('.remove-member-link a'),
      footerButtonInitialText = $(footerButtonId).text(),
      membersToRemoveArray = [];

  bindAddMemberToRemove();
  customScroll();

  $(newMemberMailTextId).keyup(function(e) {
    if($(this).val() === '') {
      $(footerButtonId).text(footerButtonInitialText);
      checkForSelectedMembers();
    } else {
      $(footerButtonId).text('Invite');
    }
  });

  $('#people-modal-footer-btn').click(function() {
    switch ($(this).text()) {
      case 'Close':
        closeMembersModal();
        break;
      case 'Invite':
        $('.submit-modal-form').click();
        break;
      case 'Remove':
        removeMembers(membersToRemoveArray);
        break;
    }
  });

  function checkForSelectedMembers() {
    if (removeMemberCheck.is(':checked')) {
      $(footerButtonId).text('Remove');
    } else {
      $(footerButtonId).text('Close');
    }
  }

  function bindAddMemberToRemove() {
    removeMemberCheck.click(function() {
      if ($(this).is(':checked')) {
        membersToRemoveArray.push(this);
      }
      checkForSelectedMembers();
    });
  }

  function removeMembers(members) {
    $(members).each(function(index, el) {
      var url = $(el).data('url'),
          type = 'DELETE',
          currentObject = {};
      ajaxCall(url,type,currentObject);
    });
    closeMembersModal();
  }
});

function closeMembersModal() {
  $('#project-members-modal').foundation('reveal', 'close');
}
