ARBOR.canvas.init = function() {
  var $canvasAttributeLinks = $('li.canvas-item');
  var $canvasAttributeFields = $('.canvas-fields');

  function showAttribute(type) {
    $('.' + type + '-field.canvas-fields').show();
  }

  $canvasAttributeLinks.click(function() {
    $canvasAttributeFields.hide();
    showAttribute($(this).attr('type'));
  });
};
