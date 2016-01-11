var formGrowInputOptions   = { minWidth: 50, maxWidth: 410, comfortZone: 0 },
    $storyModal            = $('#story-detail-modal');

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

function toggleEditCriterion() {
  $('#acceptance-list .criterion').click(function() {
    $('.show-criterion').removeClass('inactive');
    $(this).find('.show-criterion').addClass('inactive');
    $('.edit-criterion').removeClass('active');
    $(this).find('.edit-criterion').addClass('active');
    return false;
  });

  $('html').click(function() {
    if ($('.show-criterion').hasClass('inactive')) {
      $('.show-criterion').removeClass('inactive');
      $('.edit-criterion').removeClass('active');
    }
  });
}

$(document).ready(function() {
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
    toggleEditCriterion();
  });
});
