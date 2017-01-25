changeButtonColor();

function changeButtonColor() {
  var $emptyInput = $('.backlog-story-input input'),
      $role = $('#role-input'),
      $action = $('#action-input'),
      $result = $('#result-input');

  $(this).keyup(function() {
    count = $emptyInput.filter(function() {
      return $(this).val().length > 0;
    }).length;

    if (count === 3) {
      $('.create-btn').addClass('success-button');
    } else {
      $('.create-btn').removeClass('success-button');
    }
  });
}
