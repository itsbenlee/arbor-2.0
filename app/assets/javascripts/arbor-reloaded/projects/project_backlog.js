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
    $bulkMenu[$storyBulkInput.is(':checked') ? "show" : "hide"]();
  });
}

$(document).ready(function() {
  if ($('.new-backlog-story').length > 0) { autogrowInputs(); }

  if ($backlogStoryList.length) {
    showBulkMenu();
    bindReorderStories();
  }
});

$( window ).resize(function() { autogrowInputs(); });

function backlogGeneralBinds() {
  fixArticlesForRolesOnBacklog();
  showBulkMenu();
  bindReorderStories();
  autogrowInputs();
  checkEstimation();
}
