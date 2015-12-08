// functions needed on the modal view, Ale
var footerButtonInitialText = '';
$('#project-members-modal').on('opened.fndtn.reveal', function() {
  var showEditProject   = $('#show_edit_project'),
      projectDataModal  = $('.project-members'),
      editProjectForm   = $('.modal-edit-project-form'),
      footerButtonId = $('#people-modal-footer-btn');
      newMemberMailTextId = $('.new-member-mail'),
      footerButtonInitialText = $(footerButtonId).text();

  hideSpecifiedElements();
  bindActionsToButton();

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
      $('#project-members-modal').foundation('reveal', 'close');
    }
    if ($(this).text() == 'Invite') {
      $('#submit-modal-form').click();
    }
  });
}
