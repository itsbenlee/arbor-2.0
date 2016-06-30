var membersToRemoveArray = [];

$(document).on('click', '#team-members-button', {}, function(event) {
  switch ($(this).text()) {
    case 'Close':
      ModalUtils.closeMembersModal();
      break;
    case 'Invite':
      $('.submit-team-members').click();
      break;
    case 'Remove':
      TeamMembers.removeMembers(membersToRemoveArray)
    break
  }
});

$(document).on('input', '.team-member-email', {}, function(event) {
  var footerButtonInitialText = $('#team-members-button').text();

  if ($(this).val() ==='') {
    $('#team-members-button').text(footerButtonInitialText);
    TeamMembers.checkForSelectedMembers();
  } else {
    $('#team-members-button').text('Invite');
  }
});

$(document).on('click', '.remove-member-check', {}, function(event) {
  if ($(this).is(':checked')) {
    membersToRemoveArray.push(this);
  }
  TeamMembers.checkForSelectedMembers();
});

$(document).on('click', '.others', {}, function(event) {
  var $actionContainer;

  $('.actions').removeClass('visible');
  $('.icn-comments').addClass('hidden-element');
  $actionContainer = $(this).closest('li');
  $actionContainer.find($('.actions')).addClass('visible');
  event.stopPropagation();
  event.preventDefault();
});

$(document).on('click', 'html', {}, function(event) {
  if ($('.actions').hasClass('visible')) {
    $('.actions').removeClass('visible');
  }

  if ($('.deleter').hasClass('visible')) {
    $('.deleter').removeClass('visible');
  }

  if ($('.color-tags').hasClass('visible')) {
    $('.color-tags').removeClass('visible');
  }

  if ($('.icn-comments').hasClass('hidden-element')) {
    $('.icn-comments').removeClass('hidden-element');
  }

  if ($('.story-text').hasClass('shorten-story')) {
    $('.story-text').removeClass('shorten-story');
  }
});

$(document).on('click', '.delete-project, .delete-story', {}, function(event) {
  var $cancel = $('.cancel');

  $deleteContainer = $(this).closest('li');
  $deleteContainer.find($('.deleter')).addClass('visible');
  $(this).parent().removeClass('visible');

  if ($('.color-tags.visible')) {
    $('.color-tags').removeClass('visible');
  }
  event.preventDefault();
  event.stopPropagation();

  $cancel.on('click', function( e ) {
    $('.deleter').removeClass('visible');
  });
});
