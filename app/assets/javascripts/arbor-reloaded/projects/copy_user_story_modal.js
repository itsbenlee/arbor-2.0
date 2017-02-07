var $copyStories = $('#copy-stories-modal #copy_stories_submit');

function copyStories() {
  $copyStories.click(function() {
    var $selectedStories = $('.backlog-user-story input:checked'),
        url              = $(this).data('url'),
        projectId        = $('#copy_story_project_id').val();

    if ($selectedStories.length !== 0) {
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

function getStoriesId(storiesElements) {
  var storiesId = [];
  $.map(storiesElements, function(story) {
    storiesId.push(parseInt(story.value));
  });
  return storiesId;
}


$(document).ready(function() {
  $('#copy-stories-modal').foundation('reveal', {
    opened: function () {
        $('#copy-stories-modal .close').click(function(event) {
          $('#copy-stories-modal').foundation('reveal', 'close');

          event.preventDefault();
        });
      copyStories();
    }
  });
});
