function displayActions() {
  var $actionCaller = $('.others'),
      $actionContainer;

  $actionCaller.on( "click", function( event ) {
    $('.actions').removeClass('visible');
    $actionContainer = $(this).closest('li');
    $actionContainer.find($('.actions')).addClass('visible');
    return false;
  });

  $('html').click(function() {
    if ($('.actions').hasClass('visible')) {
      $('.actions').removeClass('visible');
    }

    if ($('.deleter').hasClass('visible')) {
      $('.deleter').removeClass('visible');
    }
  });
}

function displayHideDelete() {
  var $deleteCaller = $('.delete-project'),
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
});
