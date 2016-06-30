function UserStory() {
  var $storyModal     = $('#story-detail-modal'),
      $storyActions   = $storyModal.find('.story-actions');

  function NavigateUserStories() {
    $(document).unbind('keydown');
    $(document).bind('keydown', function(e) {
      var $inEditMode = $('#edit-mode').hasClass('active');

      if (!$inEditMode) {
        var $nextStory = $storyModal.find('.icn-arrow-right'),
            $prevStory = $storyModal.find('.icn-arrow-left');

        switch (e.which) {
          case 37:
            $prevStory.trigger('click');
            break;
          case 39:
            $nextStory.trigger('click');
            break;
        }
      }
    });
  }//navigate user stories

  NavigateUserStories();

  $storyModal.on('close.fndtn.reveal', function() {
    $(document).unbind('keydown');
  });
}
