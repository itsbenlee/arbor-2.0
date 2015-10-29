function Canvases() {
  var $canvasLinks       = $('li.canvas-item'),
      $canvasFields      = $('.canvas-fields'),
      $canvasTextarea    = $('.canvas-fields textarea'),
      $currentQuestion   = $('#current-question'),
      currentQuestionVal = $currentQuestion.val();

  $canvasFields.not(':eq(0)').hide();
  $canvasFields.css('opacity', 1);

  function showAttribute(type) {
    $canvasFields.hide();
    $('.' + type + '-field.canvas-fields').show();
  }

  function setVisited(type) {
    $canvasLinks.each(function(index, canvasItem) {
      var item = $(this);
      if(item.attr('type') == type) {
        item.addClass('canvas-visited');
      } else {
        item.removeClass('canvas-visited');
      }
    });
  }

  showAttribute(currentQuestionVal);
  setVisited(currentQuestionVal);

  $canvasLinks.click(function() {
    var type = $(this).attr('type');
    showAttribute(type);
    setVisited(type);
  });

  function setCurrentQuestion(question) {
    $currentQuestion.val(question);
  }

  $canvasTextarea.bind('keyup', function() {
    setCurrentQuestion($(this).data('question'));
  });
}
