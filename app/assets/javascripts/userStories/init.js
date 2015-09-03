ARBOR.user_stories.init = function() {
  var $userStoriesOnList = $('li.user-story'),
      $userStoriesList = $('ul.user-story-list'),
      $userStoryForm = $('.user-story-edit-form');

  function setBacklogOrder() {
    var newOrder = { stories: []},
        $updatedUserStoriesOnList = $('li.user-story');

    $.each($updatedUserStoriesOnList, function(index) {
      var story = { id: $(this).data('id'), backlog_order: index + 1 };
      newOrder.stories.push(story);
    });

    return newOrder;
  }

  $userStoriesOnList.click(function() {
    var url = $(this).data('url');

    $.get(url, function(editForm) {
      $userStoryForm.html('');
      $userStoryForm.html(editForm);
    });
  });

  $userStoriesList.sortable({
    connectWith: '.user-story-list',
    stop: function() {
      var newOrder = setBacklogOrder(),
          url = $userStoriesList.data('url');

      $.ajax({
        url: url,
        dataType: 'json',
        method: 'PUT',
        data: { stories: newOrder.stories }
      });
    }
  });
};
