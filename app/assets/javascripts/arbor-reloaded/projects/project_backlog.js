var commonGrowInputOptions = { minWidth: 180, maxWidth: 600, comfortZone: 30 },
    formGrowInputOptions   = { minWidth: 50, maxWidth: 410, comfortZone: 0 },
    $backlogStoryList      = $('.backlog-story-list');

// Attach autogrow on form submit, Ale
$('#new_user_story').submit(function() {
  autogrowInputs();
});

function autogrowInputs() {
  var newStoryWidth = $('.new-backlog-story').width(),
      inputMaxWidth = newStoryWidth - 90;

  $('#role-input, #action-input, #result-input').autoGrowInput({
    minWidth: 1,
    maxWidth: inputMaxWidth,
    comfortZone: 1
  });
}

function checkForEmptyGroupStories() {
  var $groupDivider = $backlogStoryList.find('.group-divider');

  $groupDivider.each(function(index, el) {
    if ($(el).find('.backlog-user-story').length) {
      $(el).find('.empty-group-text').addClass('hide');
    } else {
      $(el).find('.empty-group-text').removeClass('hide');
    }
  });
}

function bindReorderStories() {
  var $reorder_stories = $backlogStoryList.find('#ungrouped-list-container .reorder-user-stories, .active .reorder-user-stories');

  $reorder_stories.sortable({
    connectWith: '.reorder-user-stories',
    placeholder: 'sortable-placeholder',
    over: function(event, ui) {
      $(event.target).parent().find('.empty-group-text').addClass('hide');
      $(event.target).addClass('active');
    },
    out: function(event, ui) {
      $(event.target).removeClass('active');
    },
    start: function(event, ui) {
      $reorder_stories.parent().find('.empty-group-text').addClass('hide');
    },
    stop: function(event, ui) {
      checkForEmptyGroupStories();
      $(ui.item).attr('style', '');

      var newStoriesOrder = setStoriesOrder(),
          url = $reorder_stories.data('url'),
          project = $reorder_stories.data('project');

      $.ajax({
        url: url,
        dataType: 'json',
        method: 'PUT',
        data: { stories: newStoriesOrder.stories, project: project },
        success: function(response) {
          $('#groups-list-container').replaceWith(response.data);
          bindReorderStories();
          checkForEmptyGroupStories();
          displayColorTags();
          bindUserStoriesColorLinks();
          collapsableContent();
        }
      });
    }
  });
}

function setStoriesOrder() {
  var newStoriesOrder = { stories: [] },
      $updatedStoriesOnList = $('li.backlog-user-story'),
      length = $updatedStoriesOnList.length + 1;

  $.each($updatedStoriesOnList, function(index) {
    var group_id = this.parentElement.dataset.groupId,
        story    = { id: $(this).data('id'), backlog_order: length - index, group_id: group_id };

    newStoriesOrder.stories.push(story);
  });

  return newStoriesOrder;
}

function showBulkMenu() {
  var $storyModal     = $('#story-detail-modal'),
      $storyBulkInput = $backlogStoryList.find('.square-checkbox'),
      $bulkMenu       = $backlogStoryList.find('.sticky-menu');

  $storyBulkInput.click(function() {
    $bulkMenu[$storyBulkInput.is(':checked') ? 'show' : 'hide']();
  });
}

function removeColors(userStoryID) {
  var $backlogStory = $('#backlog-user-story-' + userStoryID);

  for (var i = 1; i <= 7; i++) { $backlogStory.removeClass('story-tag-' + i); }
}

function addColor(userStoryID, colorID) {
  removeColors(userStoryID);

  if (colorID) {
    $('#backlog-user-story-' + userStoryID).addClass('story-tag-' + colorID);
  }
}

function bindUserStoriesColorLinks() {
  var $colorLinks = $('.color-tag');

  $colorLinks.click(function(event) {
    var color    = $(this).data('color'),
        url      = $(this).data('url'),
        selected = $(this).data('selected'),
        storyID  = $(this).data('storyId');

    if (selected) {
      color = null;
    }

    $(this).data('selected', !selected);

    $.ajax({
      url: url,
      dataType: 'json',
      method: 'PUT',
      data: { color: color },
      success: function(data) {
        addColor(storyID, color);
      }
    });

    return false;
  });
}

function toggleGroupForm() {
  $(document).on('click', '.form-group-container h5', function(event) {
    var $this = $(this),
        $formEditName = $this.closest('.form-group-container').find('.form-container');

    $this.addClass('hidden-element');
    $formEditName.removeClass('hidden-element');
    $formEditName.find('input[name="group[name]"]').focus();
  });

  $(document).on('blur', '.form-group-container input[name="group[name]"]', function(event) {
    $this = $(this);

    $this.closest('.form-container').addClass('hidden-element');
    $this.closest('.form-group-container').find('h5').removeClass('hidden-element');
  });

  hoverNewGroupButton();
}

function hoverNewGroupButton() {
  $('.add-new-group input[name="group[name]"]')
    .focus(function(event) {
      $(this).closest('.form-group-container').css('visibility', 'visible');
    })
    .blur(function(event){
      $(this).closest('.form-group-container').removeAttr('style');
    });
}

function refreshProjectEstimations(total_points, total_cost, total_weeks) {
  $('.total_points').text(total_points);
  $('.total_cost').text(numberWithCommas(total_cost));
  $('.total_weeks').text(total_weeks);
}

function onNewBacklogStoryInputKeyup() {
  $('.backlog-story').parent('form').each(function (_, form) {
    var $backlogStoryInput = $('.backlog-story-input input', form),
        $saveStoryButton   = $('.save-user-story', form);

    $backlogStoryInput.keyup(function() {
      var count = $backlogStoryInput.filter(function() {
        return $(this).val().length > 0;
      }).length;

      if (count === $backlogStoryInput.length) {
        $saveStoryButton.addClass('complete');
      } else {
        $saveStoryButton.removeClass('complete');
      }
    });
  });
}

function fixNewBacklogStoryOnTop() {
  var $newBacklogStory        = $('.new-backlog-story'),
      $userStoryFormContainer = $('#user-story-form-container');

  if ($(window).scrollTop() >= $newBacklogStory.offset().top) {
    $userStoryFormContainer.addClass('fixed');
  } else {
    $userStoryFormContainer.removeClass('fixed');
  }
}

function fixNewBacklogStoryHeight() {
  var $newBacklogStory        = $('.new-backlog-story'),
      $userStoryFormContainer = $('#user-story-form-container');

  $newBacklogStory.height($userStoryFormContainer.outerHeight());
}

function bindCreationMode() {
  $('.backlog-story-creation-mode').each(function (i, item) {
    var $item = $(item);

    $('.creation-mode-selected', $item).click(function () {
      $('ul.creation-mode-list', $item).removeClass('hidden-element');
    });

    $('li.creation-mode-guided', $item).click(function () {
      $('.creation-mode-selected .creation-mode-icon', $item).text('G');

      $('form.creation-mode-guided').removeClass('hidden-element');
      $('form.creation-mode-freeform').addClass('hidden-element');
    });

    $('li.creation-mode-freeform', $item).click(function () {
      $('.creation-mode-selected .creation-mode-icon', $item).text('F');

      $('form.creation-mode-guided').addClass('hidden-element');
      $('form.creation-mode-freeform').removeClass('hidden-element');
    });
  });

  $(document).click(function (event) {
    var $element = $(event.target);

    if ($element.parents('.creation-mode-selected').length !== 1 &&
        !$element.is('.creation-mode-selected')) {
      $('ul.creation-mode-list').addClass('hidden-element');
    }
  });
}

$(document).ready(function() {
  if ($('.new-backlog-story').length > 0) { autogrowInputs(); }

  if ($backlogStoryList.length) {
    bindCreationMode();
    showBulkMenu();
    bindReorderStories();
    checkForEmptyGroupStories();
    bindUserStoriesColorLinks();
    toggleGroupForm();
  }

  if ($('.new-backlog-story').length > 0) {
    onNewBacklogStoryInputKeyup();
    fixNewBacklogStoryHeight();
    $(window)
      .scroll(fixNewBacklogStoryOnTop)
      .resize(fixNewBacklogStoryHeight);
  }
});

$(window).resize(function() { autogrowInputs(); });

function backlogGeneralBinds() {
  fixArticlesForRolesOnBacklog();
  showBulkMenu();
  bindReorderStories();
  autogrowInputs();
  checkEstimation();
  collapsableContent();
  checkForEmptyGroupStories();
  displayActions();
  displayHideDelete();
  displayColorTags();
  bindUserStoriesColorLinks();
}
