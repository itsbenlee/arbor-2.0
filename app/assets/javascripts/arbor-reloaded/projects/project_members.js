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

  hideSpecifiedElements();
  bindActionsToButton();
  bindActionsOnRemovalCheckboxes();
  displayInitialWhenNoAvatar();

  $(newMemberMailTextId).keyup(function(e) {
   if($(this).val() == '') {
     $(footerButtonId).text(footerButtonInitialText);
   } else {
     $(footerButtonId).text('Invite');
   }
 });
  new Projects();
});

function hideSpecifiedElements() {
  $('.hidden-input-element').each(function(index, currentValue) {
    $(currentValue).hide();
  });
}

//button function depending on what it says, Ale
function bindActionsToButton() {
  $('#people-modal-footer-btn').click(function(){
    if ($(this).text() == 'Close') {
      closeMembersModal();
    }
    if ($(this).text() == 'Invite') {
      $('#submit-modal-form').click();
    }
  });
}

function displayInitialWhenNoAvatar() {
  $('.user-item.invited.row').has('.avatar-circle').each(function(index, currentValue) {
    if ($(currentValue).children('.user-data').children('.reloaded-tag').text().trim() == 'Invited'){
      var initial = $(currentValue).children('.user-data').children('.user-mail').text().trim().substring(0,1);
      $(currentValue).children('.profile').children('.avatar-circle').text(initial.toUpperCase());
    }
  });
}

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
