function UserStory() {
  var $points       = $('.fibonacci-select'),
      $sentence     = $('.sentence'),
      $criterion    = $('.show-criterion'),
      $storyModal   = $('#story-detail-modal'),
      $storyActions = $storyModal.find('.story-actions'),
      $storyList    = $('.user-stories-container'),
      $story        = $storyList.find('.story-detail-link'),
      $storyOpened  = $('.story-detail-link.opened');

  function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }

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
          $('.total_points').text(response.data.total_points);
          $('.total_cost').text(numberWithCommas(response.data.total_cost));
          $('.total_weeks').text(response.data.total_weeks);
          displayEstimation(response.data);
        }
      }
    });
  });

  function displayEstimation(data) {
    if (data.estimated_points) {
      $('.backlog-user-story[data-id='+ data.id +']')
      .find('.story-points').text(data.estimated_points);
    }
    else {
      $('.backlog-user-story[data-id='+ data.id +']').find('.story-points').text('?');
    }
  }

  function NavigateUserStories() {
    $(document).unbind('keydown');
    $(document).bind('keydown', function(e) {
      var $inEditMode = $('#edit-mode').hasClass('active');

      if (!$inEditMode) {
        var $nextStory = $storyModal.find('.icn-arrow-right'),
            $prevStory = $storyModal.find('.icn-arrow-left');

        switch (e.which) {
          case 37:
            $prevStory.trigger('click');
            break;
          case 39:
            $nextStory.trigger('click');
            break;
        }
      }
    });
  }//navigate user stories

  toggleDeleteConfirmation();
  toggleModalStoryDropdown();
  toggleEditCriterion();
  displayEditionForm();
  NavigateUserStories();
  displaySaveButton();

  function displaySaveButton() {
    $('.show-criterion').on("click", function() {
      $(this).next().find('#save-acceptance-criterion').removeClass('hidden-element');
    });

    $('.save-ac-button').on( "click", function() {
      $(this).addClass('hidden-element');
    });
  }

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
      $('#acceptance-list .delete-criterion').removeClass('active');

      $(this).find('.edit-criterion').addClass('active');
      $('#acceptance-list .delete-criterion[data-id='+ $(this).data('id') +']').addClass('active');
      event.stopPropagation();
    });

    $('html').click(function() {
      if ($('.show-criterion').hasClass('inactive')) {
        $('.show-criterion').removeClass('inactive');
        $('.edit-criterion').removeClass('active');
        $('.delete-criterion').removeClass('active');
      }
    });
  }

  $storyModal.on('close.fndtn.reveal', function() {
    $(document).unbind('keydown');
  });
}
