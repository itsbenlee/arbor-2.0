function ModalUtils() {}

ModalUtils.displayEstimation = function(data) {
  if (data.estimated_points) {
    $('.backlog-user-story[data-id='+ data.id +']')
    .find('.story-points').text(data.estimated_points);
  }
  else {
    $('.backlog-user-story[data-id='+ data.id +']').find('.story-points').text('?');
  }
}

ModalUtils.closeMembersModal = function() {
  $('#team-members-modal').foundation('reveal', 'close');
}
