// functions needed on the modal view, Ale
var footerButtonInitialText = '';
$('#project-members-modal').on('opened.fndtn.reveal', function() {
  var showEditProject   = $('#show_edit_project'),
      projectDataModal  = $('.project-members'),
      editProjectForm   = $('.modal-edit-project-form'),
      footerButtonId = $('#people-modal-footer-btn');
      newMemberMailTextId = $('.new-member-mail'),
      removeMemberFromProjectCheck = $('#remove-member-check'),
      removeMemberFromProjectLink = $('.remove-member-link a'),
      footerButtonInitialText = $(footerButtonId).text();

  bindActionsOnRemovalCheckboxes();
  customScroll();

  $(newMemberMailTextId).keyup(function(e) {
    if($(this).val() === '') {
      $(footerButtonId).text(footerButtonInitialText);
    } else {
      $(footerButtonId).text('Invite');
    }
  });

  $('#people-modal-footer-btn').click(function() {
    if ($(this).text() == 'Close') {
      closeMembersModal();
    }
    if ($(this).text() == 'Invite') {
      $('.submit-modal-form').click();
    }
  });
});

//checkbox events on checked, Ale
function bindActionsOnRemovalCheckboxes() {
  removeMemberFromProjectCheck.click(function() {
    if ($(this).is(':checked')) {
      if ( confirm('Are you sure you want to remove the member?') ){
        var url = $(this).data('url'),
            type = 'DELETE',
            currentObject = {};
        ajaxCall(url,type,currentObject);
        closeMembersModal();
        alert('Member has been removed from project');
      }
      return false;
    }
  });
}

function closeMembersModal() {
  $('#project-members-modal').foundation('reveal', 'close');
}
