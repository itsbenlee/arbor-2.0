function UserStory() {
  var $points = $('.fibonacci-select'),
      $moreActions = $('.story-actions-link'),
      $sentence = $('.sentence'),
      $criterion = $('.show-criterion')

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
}
