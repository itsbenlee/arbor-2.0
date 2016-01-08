var commonGrowInputOptions = { minWidth: 180, maxWidth: 600, comfortZone: 30 },
    formGrowInputOptions   = { minWidth: 50, maxWidth: 410, comfortZone: 0 },
    $backlogStoryList      = $('.backlog-story-list'),
    $storyModal            = $('#story-detail-modal'),
    $storyBulkInput        = $backlogStoryList.find('.circle-checkbox'),
    $bulkMenu              = $backlogStoryList.find('.sticky-menu');

// Attach autogrow on form submit, Ale
$('#new_user_story').submit(function() {
  autogrowInputs();
});

function autogrowInputs() {
  $('#role-input, #action-input, #result-input').trigger('autogrow');
}

function bindReorderStories() {
  $('.backlog-story-list').sortable({
    connectWith: '.backlog-story-list',
    stop: function() {
      var newStoriesOrder = setStoriesOrder(),
          url = $('.backlog-story-list').data('url');
          project = $('.backlog-story-list').data('project');
      $.ajax({
        url: url,
        dataType: 'json',
        method: 'PUT',
        data: { stories: newStoriesOrder.stories, project: project }
      });
    }
  });
}

function setStoriesOrder() {
  var newStoriesOrder = { stories: [] },
      $updatedStoriesOnList = $('li.backlog-user-story');

  $.each($updatedStoriesOnList, function(index) {
    var story = { id: $(this).data('id'), backlog_order: index + 1 };
    newStoriesOrder.stories.push(story);
  });

  return newStoriesOrder;
}

function showBulkMenu() {
  $storyBulkInput.click(function() {
    $bulkMenu[$storyBulkInput.is(':checked') ? "show" : "hide"]();
  });
}

function toggleModalStoryDropdown() {
  var $trigger = $storyActions.find('.story-actions-link'),
      $actions = $storyActions.find('a').not($trigger);

  $trigger.click(function() {
    $(this).addClass('open');
    $actions.addClass('active');
    return false;
  });

  $('html').click(function() {
    if ($trigger.hasClass('open')) {
      $trigger.removeClass('open');
      $actions.removeClass('active');
    }
  });
}//toggle actions dropwdon on modal

function toggleDeleteConfirmation() {
  var $delete              = $storyActions.find('.icn-delete'),
      $confirmationWarning = $storyModal.find('.delete-confirmation-overlay'),
      $headerWrapper       = $storyModal.find('header .header-wrapper');

  $delete.click(function() {
    $headerWrapper.addClass('inactive');
    $confirmationWarning.addClass('active');
    return false;
  });

  $('html').click(function() {
    if ($confirmationWarning.hasClass('active')) {
      $confirmationWarning.removeClass('active');
      $headerWrapper.removeClass('inactive');
    }
  });
}//show delete confirmation

function changeFibonnacciEstimation() {
  var $estimationPoints = $storyModal.find('.story-points'),
      $dropdown = $storyModal.find('.fibonacci-select');

  $dropdown.change(function(event) {
    $estimationPoints.html(this.value);
  });
}

function displayEditionForm() {
  var $editUserStory       = $('.edit_user_story'),
      $editUserStoryInputs = $editUserStory.find('input').not(':input[type=button], :input[type=submit], :input[type=reset]');
  $('.story-text').on( "click", function() {
    $editUserStoryInputs.autoGrowInput(formGrowInputOptions);
    $('.edition-form').addClass('active');
    $('.header-wrapper').addClass('inactive');
  });

  $('.actions .close-edition').on( "click", function() {
    $('.edition-form').removeClass('active');
    $('.header-wrapper').removeClass('inactive');
  });
}


$(document).ready(function() {
  if ($('.new-backlog-story').length > 0) {
    $('#role-input').autoGrowInput(commonGrowInputOptions);
    $('#action-input').autoGrowInput(commonGrowInputOptions);
    $('#result-input').autoGrowInput(commonGrowInputOptions);
    autogrowInputs();
  }

  if ($backlogStoryList.length) {
    showBulkMenu();
    bindReorderStories();
  }

  $('#story-detail-modal').foundation('reveal', {
    opened: function () {
      displayEditionForm();
    }
  });

  $storyModal.on('opened.fndtn.reveal', function() {
    $storyActions = $storyModal.find('.story-actions');
    toggleModalStoryDropdown();
    toggleDeleteConfirmation();
    changeFibonnacciEstimation();
  });
});
