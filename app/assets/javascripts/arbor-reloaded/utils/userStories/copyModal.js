function CopyModal() {
  var $copyStoriesBtn          = $('button#copy_stories_submit'),
      $copyStoriesErrorMessage = $('.copy-stories-error');

  function hideMessages() {
    $copyStoriesErrorMessage.hide();
  }

  function showErrorMessage() {
    $copyStoriesErrorMessage.show();
  }

  function getStoriesId(storiesElements) {
    var storiesId = [];
    $.map(storiesElements, function(story) {
      storiesId.push(parseInt(story.value));
    });
    return storiesId;
  }

  $copyStoriesBtn.click(function() {
    var $selectedStories = $('.copy-story-check-box input:checked'),
        url              = $(this).data('url'),
        projectId        = $('#copy_story_project_id').val();
    hideMessages();

    if($selectedStories.length === 0) {
      showErrorMessage();
    } else {
      $.ajax({
        type: 'POST',
        url: url,
        data: { user_stories: getStoriesId($selectedStories),
          project_id: projectId },
        success: function(response) {
          window.location.href = response.project_url;
        }
      });
    }
  });
}
