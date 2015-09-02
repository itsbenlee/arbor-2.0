ARBOR.user_stories.init = function() {
  var $userStoriesOnList = $('li.user-story'),
      $userStoryForm = $('.user-story-edit-form');

  $userStoriesOnList.click(function() {
    var url = $(this).data('url');

    $.get(url, function(editForm) {
      $userStoryForm.html('');
      $userStoryForm.html(editForm);
    });
  });
};
