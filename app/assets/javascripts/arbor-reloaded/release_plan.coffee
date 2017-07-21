$(document).ready ->
  return unless $('#release_plan_table').length

  $(document).on 'mouseenter', '.user-story-status', ->
    sprintID = $(this).data('sprint-id')
    $(".user-story-#{sprintID} a").addClass('release-plan-selected-column');

  $(document).on 'mouseleave', '.user-story-status', ->
    sprintID = $(this).data('sprint-id')
    $(".user-story-#{sprintID} a").removeClass('release-plan-selected-column');
