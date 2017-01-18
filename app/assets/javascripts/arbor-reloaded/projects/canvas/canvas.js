function Canvas() {
  $('.question-form .question').click(function() {
    $('.body').removeClass('edit');

    var $body = $(this).closest('.body'),
        $textarea = $body.find('textarea'),
        text = $textarea.val();

    $body.addClass('edit');
    $textarea.focus().val('').val(text);
  });

  $('.question-form .cancel').click(function() {
    var $body = $(this).closest('.body');
    $body.removeClass('edit');
  });
}
