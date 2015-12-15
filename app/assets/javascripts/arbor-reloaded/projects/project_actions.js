function displayActions() {
  var $actionCaller = $('.others'),
      $actionPannel = $('.actions');

  $actionCaller.click(function(event){
    $actionPannel.addClass('visible');
    event.stopPropagation();
    return false;
  });

  $('html').click(function() {
    $actionPannel.removeClass('visible');
    return false;
  });
}

$( document ).ready(function() {
  if (typeof $('.others') != "undefined") {
    displayActions();
  }
});
