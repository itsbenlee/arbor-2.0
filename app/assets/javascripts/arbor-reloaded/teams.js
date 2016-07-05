function TeamMembers() {}

TeamMembers.checkForSelectedMembers = function() {
  var footerButtonId = $('#team-members-button');

  if ($('.remove-member-check').is(':checked')) {
    $(footerButtonId).text('Remove');
  } else {
    $(footerButtonId).text('Close');
  }
}

TeamMembers.removeMembers= function(members) {
  $(members).each(function(index, el) {
    $.ajax({
      type: 'DELETE',
      url: $(el).data('url'),
      success: function (response) {
        $('.members-avatars').html(response);
      }
    });
    $('#team-members-button').text('Close')
  });
}

$(document).ready(function() {
  customScroll();
});
