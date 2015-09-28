function UserStory() {
  var $userStoriesList  = $('.user-story-list'),
      $newUserStoryForm = $('form#new_user_story'),
      $appContent       = $('.right-app-content');

  function storiesAreReordered(hypothesisId, stories) {
    var changes = false;

    $.each(stories, function (index) {
      if($(this).data('hypothesis-id') !== hypothesisId ||
        $(this).data('order') !== (index + 1) ) {
        changes = true;
        return false;
      }
    });
    return changes;
  }

  function getHypothesesWhichChanged() {
    var hypotheses = [];
    $.each($userStoriesList, function() {
      var hypothesisId = $(this).data('hypothesis-id'),
          hypothesisChange =
            storiesAreReordered(hypothesisId, $(this).children());

      if(hypothesisChange) hypotheses.push(hypothesisId);
    });
    return hypotheses;
  }

  function setStoriesObject($stories, hypothesisObject) {
    $.each($stories, function (index) {
      var story = {
        id: $(this).data('id'),
        order: index + 1
      };
      hypothesisObject.stories.push(story);
    });
  }

  function setHypothesisObject(updatedHypothesis) {
    var hypothesisObject = { id: null, stories: [] };
    hypothesisObject.id = updatedHypothesis.data('hypothesis-id');
    setStoriesObject(updatedHypothesis.children('.user-story'), hypothesisObject);
    return hypothesisObject;
  }

  function updateHypotheses(updatedHypothesisIds) {
    var newOrder = { hypotheses: []},
        url = $userStoriesList.data('url');
    $.each(updatedHypothesisIds, function(index, hypothesisId) {
      var updatedHypothesis = $userStoriesList.filter('[data-hypothesis-id='+
        hypothesisId +']');

      newOrder.hypotheses.push(setHypothesisObject(updatedHypothesis));
    });

    $.ajax({
      url: url,
      dataType: 'json',
      method: 'PUT',
      data: { hypotheses: newOrder.hypotheses }
    });
  }

  function hideHypothesis(hypothesisId) {
    var $preloader  = $('.hypothesis-preloader[data-id=' + hypothesisId + ']');
    $('.hypothesis[data-id=' + hypothesisId + ']').hide();
    $preloader.show();
    $appContent.scrollTo($preloader, 300);
  }

  function showHypothesis(hypothesisId) {
    $('.hypothesis-preloader[data-id=' + hypothesisId + ']').hide();
    $('.hypothesis[data-id=' + hypothesisId + ']').show();
  }

  function refreshHypothesis(hypothesisId, userStoryId) {
    $.get('/hypotheses/' + hypothesisId + '/user_stories',
      function(storiesHTML) {
        var $storiesList = $('.stories-list[data-hypothesis-id=' +
              hypothesisId + ']');
        $storiesList.html('');
        $storiesList.html(storiesHTML);

        showHypothesis(hypothesisId);

        bindUserStoriesSortEvent();
        var $userStoryForm = $('#edit_user_story_' + userStoryId);
        $appContent.scrollTo($userStoryForm, 200);
    });
  }

  function bindUserStoriesSortEvent() {
    var storyListSelector = '.user-story-list';
    $userStoriesList = $(storyListSelector);
    $userStoriesList.sortable({
      connectWith: storyListSelector,
      stop: function() {
        var hypotheses = getHypothesesWhichChanged();
        updateHypotheses(hypotheses);
      }
    });
  }

  bindUserStoriesSortEvent();
  $newUserStoryForm.submit(function() {
    var url          = $(this).attr('action'),
        type         = $(this).attr('method'),
        userStory    = $(this).serialize(),
        hypothesisId = $(this).data('hypothesisId');

    hideHypothesis(hypothesisId);

    $.ajax({
      type: type,
      url: url,
      data: userStory,
      success: function (response) {
        if(response.success) {
          refreshHypothesis(hypothesisId, response.data.user_story_id);
          $newUserStoryForm.trigger('reset');
        }
      }
    });

    return false;
  });
}
