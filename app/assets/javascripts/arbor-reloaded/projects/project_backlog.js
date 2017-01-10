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
  var $reorder_stories = $backlogStoryList.find('.reorder-user-stories');

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
          url = $reorder_stories.data('url');
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

function removeColors(userStoryID) {
  var $backlogStory = $('#backlog-user-story-' + userStoryID);
  for (var i = 1; i <= 7; i++) { $backlogStory.removeClass('story-tag-' + i); }
}

function addColor(userStoryID, colorID) {
  removeColors(userStoryID);
  if(colorID) {
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

    if(selected) {
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
    $this = $(this);
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
      $(this).closest(".form-group-container").css('visibility', 'visible');
    })
    .blur(function(event){
      $(this).closest(".form-group-container").removeAttr("style");
    });
}

$(document).ready(function() {
  if ($('.new-backlog-story').length > 0) { autogrowInputs(); }

  if ($backlogStoryList.length) {
    showBulkMenu();
    bindReorderStories();
    checkForEmptyGroupStories();
    bindUserStoriesColorLinks();
    toggleGroupForm();
  }
});

$( window ).resize(function() { autogrowInputs(); });

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
