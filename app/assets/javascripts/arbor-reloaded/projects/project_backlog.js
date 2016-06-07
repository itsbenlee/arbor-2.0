var commonGrowInputOptions = { minWidth: 180, maxWidth: 600, comfortZone: 30 },
    formGrowInputOptions   = { minWidth: 50, maxWidth: 410, comfortZone: 0 },
    $backlogStoryList      = $('.backlog-story-list');

// Attach autogrow on form submit, Ale
$('#new_user_story').submit(function() {
  autogrowInputs();
});

function autogrowInputs() {
  $('#role-input, #action-input, #result-input').trigger('autogrow');
}

function bindReorderStories() {
  var $reorder_stories = $backlogStoryList.find('.reorder-user-stories');
  $reorder_stories.sortable({
    connectWith: '.reorder-user-stories',
    stop: function() {
      var newStoriesOrder = setStoriesOrder(),
          url = $reorder_stories.data('url');
          project = $reorder_stories.data('project');
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
      length = $updatedStoriesOnList.length + 1;

  $.each($updatedStoriesOnList, function(index) {
    var story = { id: $(this).data('id'), backlog_order: length - index };
    newStoriesOrder.stories.push(story);
  });

  return newStoriesOrder;
}

function showBulkMenu() {
  var $storyModal     = $('#story-detail-modal'),
      $storyBulkInput = $backlogStoryList.find('.square-checkbox'),
      $bulkMenu       = $backlogStoryList.find('.sticky-menu');

  $storyBulkInput.click(function() {
    $bulkMenu[$storyBulkInput.is(':checked') ? "show" : "hide"]();
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
});

function backlogGeneralBinds() {
  fixArticlesForRolesOnBacklog();
  showBulkMenu();
  bindReorderStories();
  autogrowInputs();
  checkEstimation();
}
