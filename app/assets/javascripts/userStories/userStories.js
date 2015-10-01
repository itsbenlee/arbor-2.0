function UserStories() {
  var $userStoriesOnList    = $('li.user-story'),
      $userStoriesList      = $('ul.user-story-list'),
      $userStoryForm        = $('.user-story-edit-form'),
      $newUserStoryForm     = $('form#new_user_story'),
      $backlogSection       = $('section.backlog'),
      $userStoriesContainer = $('.user-stories-list-container'),
      $backlogPreloader     = $('.user-stories-preloader'),
      projectId             = $backlogSection.data('projectId');

  function setBacklogOrder() {
    var newOrder = { stories: [] },
        $updatedUserStoriesOnList = $('li.user-story');

    $.each($updatedUserStoriesOnList, function(index) {
      var story = { id: $(this).data('id'), backlog_order: index + 1 };
      newOrder.stories.push(story);
    });

    return newOrder;
  }

  function displayStoryForm(url) {
    $.get(url, function(editForm) {
      $userStoryForm.html('');
      $userStoryForm.html(editForm);
      bindUserStoryEditForm();
      bindNewAcceptanceCriterion();
      bindNewConstraint();
      bindEditAcceptanceCriterion();
      bindEditConstraint();
    });
  }

  function bindUserStoriesEvents() {
    $userStoriesOnList.click(function() {
      var url = $(this).data('url');
      displayStoryForm(url);
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
  }

  function hideBacklog() {
    $userStoriesContainer.hide();
    $backlogPreloader.show();
  }

  function showBacklog() {
    $backlogPreloader.hide();
    $userStoriesContainer.show();
  }

  function refreshBacklog() {
    $.get('backlog', function(backlogHTML) {
      $userStoriesContainer.html('');
      $userStoriesContainer.html(backlogHTML);
      $userStoriesOnList = $('li.user-story');
      $userStoriesList   = $('ul.user-story-list');
      bindUserStoriesEvents();
      showBacklog();
    });
  }

  function editFormAjax(url, type, currentObject) {
    hideBacklog();

    $.ajax({
      type: type,
      url: url,
      data: currentObject,
      success: function (response) {
        if(response.success) {
          refreshBacklog();
          editUrl = response.data.edit_url
          displayStoryForm(editUrl);
        }
      }
    });
  }

  bindUserStoriesEvents();
  $newUserStoryForm.submit(function() {
    var url       = $(this).attr('action'),
        type      = $(this).attr('method'),
        userStory = $(this).serialize();

    editFormAjax(url, type, userStory);
    return false;
  });

  function bindNewAcceptanceCriterion() {
    $newCriterionForm = $('.new_acceptance_criterion');

    $newCriterionForm.submit(function() {
      var url        = $(this).attr('action'),
          type       = $(this).attr('method'),
          acriterion = $(this).serialize();

      editFormAjax(url, type, acriterion);
      return false;
    });
  }

  function bindEditAcceptanceCriterion() {
    $editCriterionForm = $('.edit_acceptance_criterion');

    $editCriterionForm.submit(function() {
      var url        = $(this).attr('action'),
          type       = $(this).attr('method'),
          acriterion = $(this).serialize();

      editFormAjax(url, type, acriterion);
      return false;
    });
  }

  function bindUserStoryEditForm() {
    $editUserStoryForm = $('form.edit-story.edit_user_story');

    $editUserStoryForm.submit(function() {
      var url       = $(this).attr('action'),
          type      = $(this).attr('method'),
          userStory = $(this).serialize();

      editFormAjax(url, type, userStory);
      return false;
    });
  }

  function bindNewConstraint() {
    $newConstraintForm = $('.new_constraint');

    $newConstraintForm.submit(function() {
      var url        = $(this).attr('action'),
          type       = $(this).attr('method'),
          constraint = $(this).serialize();

      editFormAjax(url, type, constraint);
      hideBacklog();
      return false;
    });
  }

  function bindEditConstraint() {
    $editConstraintForm = $('.edit_constraint');

    $editConstraintForm.submit(function() {
      var url        = $(this).attr('action'),
          type       = $(this).attr('method'),
          constraint = $(this).serialize();

      editFormAjax(url, type, constraint);
      return false;
    });
  }
}
