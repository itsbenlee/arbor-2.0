function checkEstimation() {
  var estimation = $('.estimation.row');

  if (estimation.hasClass( 'hide' )) {
    estimation.removeClass('hide');
  }
}

function hideShowEstimation() {
  var triggerHideShow = $('.estimation .toggle-estimation'),
      estimationBoxes = $('.estimation-wrapper');
  triggerHideShow.click(function () {
    estimationBoxes.fadeToggle();
    $(this).toggleClass('active');
  });
}
