ARBOR.canvases.init = function() {
  var $canvasAttributeLinks = $('li.canvas-item');
  var $canvasAttributeFields = $('.canvas-fields');

  function showAttribute(type) {
    $('.' + type + '-field.canvas-fields').show();
  }

  function setVisited(type) {
    $.each($canvasAttributeLinks, function(index, canvasItem) {
      var item = $(this);
      if(item.attr('type') == type) {
        item.addClass('canvas-visited');
      } else {
        item.removeClass('canvas-visited');
      }
    });
  }

  $canvasAttributeLinks.click(function() {
    $canvasAttributeFields.hide();
    var type = $(this).attr('type');
    showAttribute(type);
    setVisited(type);
  });
};
