var selectBoxSelectors = '.fibonacci-select, .fibonacci-common-select, .groups-common-select';

$(document).on('change', selectBoxSelectors, {}, function(event){
  var story_id          = $(this).data('id'),
      $estimationPoints = $('.story-points[data-id="' + story_id + '"]'),
      group_id          = $('#groups-common-select-' + story_id)[0].value,
      estimated_points  = this.value,
      groups_url        = this.dataset.groupsUrl,
      ungrouped_url     = this.dataset.ungroupedUrl,
      group_edition     = $(this).hasClass('groups-common-select');

  if(group_edition) {
    estimated_points = $estimationPoints.text();
  } else {
    $('.fibonacci-select').val(this.value);
    $('.fibonacci-common-select').val(this.value);
  }

  $estimationPoints.html(estimated_points);

  $('#estimation-edited-' + story_id).hide();
  $('#group-edited-' + story_id).hide();

  $.ajax({
    url: $(this).data('url'),
    dataType: 'json',
    method: 'PUT',
    data: { user_story: { estimated_points: estimated_points, group_id: group_id } },
    success: function (response) {
      if(response.success) {
        refreshProjectEstimations(response.data.total_points, response.data.total_cost, response.data.total_weeks);
        ModalUtils.displayEstimation(response.data);

        $.when($.get(groups_url), $.get(ungrouped_url)).done(function(groupsData, ungroupedData) {
          $('#groups-list-container').empty().html(groupsData[0]);
          $('#ungrouped-list-container').empty().html(ungroupedData[0]);
          bindReorderStories();
          group_edition ? $('#group-edited-' + story_id).show() : $('#estimation-edited-' + story_id).show();
        });
      }
    }
  });
});

$(document).on('click', '#acceptance-list .criterion', {}, function(event) {
  $('.show-criterion').removeClass('inactive');
  $(this).find('.show-criterion').addClass('inactive');
  $('.edit-criterion').removeClass('active');
  $('#acceptance-list .delete-criterion').removeClass('active');

  $(this).find('.edit-criterion').addClass('active');
  $('#acceptance-list .delete-criterion[data-id='+ $(this).data('id') +']').addClass('active');
  event.stopPropagation();

  $('html').click(function() {
    if ($('.show-criterion').hasClass('inactive')) {
      $('.show-criterion').removeClass('inactive');
      $('.edit-criterion').removeClass('active');
      $('.delete-criterion').removeClass('active');
    }
  });
});

$(document).on('click', '.story-actions .icn-delete', {}, function(event) {
  var $storyModalHeader    = $(this).parent().parent().parent(),
      $confirmationWarning = $storyModalHeader.find('.delete-confirmation-overlay'),
      $headerWrapper       = $storyModalHeader.find('.header-wrapper');

  $headerWrapper.addClass('inactive');
  $confirmationWarning.addClass('active');
  return false;
});

$(document).on('click', '.story-actions-link', {}, function(event) {
  $(this).addClass('open');
  $(this).siblings().addClass('active');
  return false;
});

$(document).on('click', '.show-criterion', {}, function(event) {
  $(this).next().find('#save-acceptance-criterion').removeClass('hidden-element');
});

$(document).on('click', '.save-ac-button', {}, function(event) {
  $(this).addClass('hidden-element');
});

$(document).on('click', '.story-text', {}, function(event) {
  var undesired_types = (':input[type=button], :input[type=submit], :input[type=reset]');
  $('.edit_user_story').find('input').not(undesired_types);

  $('.edition-form').addClass('active');
  $('.header-wrapper').addClass('inactive');
});

$(document).on('click', '.actions .close-edition', {}, function(event) {
  $('.edition-form').removeClass('active');
  $('.header-wrapper').removeClass('inactive');
});
