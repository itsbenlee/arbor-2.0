function UserStory() {
  var $points       = $('.fibonacci-select'),
      $sentence     = $('.sentence'),
      $criterion    = $('.show-criterion'),
      $storyModal   = $('#story-detail-modal'),
      $storyActions = $storyModal.find('.story-actions');

  $points.change(function(event) {
    var story_id = $(this).data('id'),
        $estimationPoints = $('.story-points[data-id="' + story_id + '"]');
    $estimationPoints.html(this.value);
    $.ajax({
      url: $(this).data('url'),
      dataType: 'json',
      method: 'PUT',
      data: { user_story: { estimated_points: this.value } },
      success: function (response) {
        if(response.success) {
          if (response.data.estimated_points !== null)
            $('.backlog-user-story[data-id='+ response.data.id +']')
            .find('.story-points').text(response.data.estimated_points);
          else {
            $('.backlog-user-story[data-id='+ response.data.id +']').find('.story-points').text('?')
          }
        }
      }
    });
  });

  toggleDeleteConfirmation();
  toggleModalStoryDropdown();
  toggleEditCriterion();
  displayEditionForm();

  function displayEditionForm() {
    var $editUserStory       = $('.edit_user_story'),
        undesired_types      =
          (':input[type=button], :input[type=submit], :input[type=reset]'),
        $editUserStoryInputs = $editUserStory.find('input').not(undesired_types);
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
}
