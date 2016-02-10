function displayActions() {
  var $actionCaller = $('.others'),
      $actionContainer;

  $actionCaller.on( "click", function( event ) {
    $('.actions').removeClass('visible');
    $('.icn-comments').addClass('hidden-element');
    $actionContainer = $(this).closest('li');
    $actionContainer.find($('.actions')).addClass('visible');
    event.stopPropagation();
    event.preventDefault();
  });

  $('html').click(function() {
    if ($('.actions').hasClass('visible')) {
      $('.actions').removeClass('visible');
    }

    if ($('.deleter').hasClass('visible')) {
      $('.deleter').removeClass('visible');
    }

    if ($('.icn-comments').hasClass('hidden-element')) {
      $('.icn-comments').removeClass('hidden-element');
    }
  });
}

function displayHideDelete() {
  var $deleteCaller = $('.delete-project, .delete-story'),
      $cancel       = $('.cancel');
  $deleteCaller.on( "click", function( event ) {
    $deleteContainer = $(this).closest('li');
    $deleteContainer.find($('.deleter')).addClass('visible');
    $(this).parent().removeClass('visible');
    return false;
  });

  $cancel.on('click', function( e ) {
    $('.deleter').removeClass('visible');
  });
}

$( document ).ready(function() {
  generalBinds();
  bindAutoReveal();
  hideShowEstimation();
});
