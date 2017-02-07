function displayActions() {
  var $actionCaller = $('.others'),
      $actionContainer;

  $actionCaller.on('click', function(event) {
    $('.actions').removeClass('visible');
    $('.icn-comments').addClass('hidden-element');
    $actionContainer = $(this).closest('li');
    $actionContainer.find($('.actions')).addClass('visible');

    event.stopPropagation();
    event.preventDefault();
  });

  $('html').click(function() {
    $('.actions,.deleter,.color-tags').removeClass('visible');

    if ($('.icn-comments').hasClass('hidden-element')) {
      $('.icn-comments').removeClass('hidden-element');
    }

    if ($('.story-text').hasClass('shorten-story')) {
      $('.story-text').removeClass('shorten-story');
    }
  });
}

function displayHideDelete() {
  var $deleteCaller = $('.delete-project, .delete-story'),
      $cancel       = $('.cancel');

  $deleteCaller.on('click', function(event) {
    $deleteContainer = $(this).closest('li');
    $deleteContainer.find($('.deleter')).addClass('visible');
    $(this).parent().removeClass('visible');

    if ($('.color-tags.visible')) {
      $('.color-tags').removeClass('visible');
    }

    event.preventDefault();
    event.stopPropagation();
  });

  $cancel.on('click', function(event) {
    $('.deleter').removeClass('visible');

    event.preventDefault();
  });
}

$(document).ready(function() {
  generalBinds();
  bindAutoReveal();
  collapsableContent();
  moveUpTheme();
  moveDownTheme();
  toggleStatusTheme();
});
