function UserStory() {
  var $storyModal     = $('#story-detail-modal'),
      $storyActions   = $storyModal.find('.story-actions');

  $storyModal.on('close.fndtn.reveal', function() {
    $(document).unbind('keydown');
  });
}
