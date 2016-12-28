function displayColorTags() {
  var $colorTrigger = $('.user-stories-container .color-story');

  $colorTrigger.each(function(index, el) {
    $(el).click(function(event) {
      event.preventDefault();
      event.stopPropagation();
      $(this).parent().next('.color-tags').toggleClass('visible');
    });
  });
}
