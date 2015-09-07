function Goal() {
  var $goalItem = $('.goal-item'),
      $editableGoalItem = $('.goal-item-editable');

  $goalItem.click(function(){
    var goalId = $(this).data('goalId'),
        $goalForm = $('.goal-item-editable[data-goal-id=' + goalId + ']');

    $editableGoalItem.hide();
    $goalForm.show();
    $(this).hide();
  });
}
