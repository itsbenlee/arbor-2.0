function storiesWidth() {
  $('a.delete-story, a.color-story').click(function(event) {
    var storyId = $(this).data('id'),
        storySelector = '#story-text-'+ storyId;
    if ($(storySelector).hasClass('shorten-story')) {
      $(storySelector).removeClass('shorten-story');
    } else {
      $(storySelector).addClass('shorten-story');
    }
  });

  $('a.cancel').on( "click", function() {
    var storyId = $(this).data('id'),
        storySelector = '#story-text-'+ storyId;
    $(storySelector).removeClass('shorten-story');
  });
}
