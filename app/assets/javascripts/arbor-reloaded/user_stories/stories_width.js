function storiesWidth() {
  $('a.delete-story').on( "click", function() {
    var storyId = $(this).data('id'),
        storySelector = '#story-text-'+ storyId;
    $(storySelector).addClass('shorten-story');
  });

  $('a.cancel').on( "click", function() {
    var storyId = $(this).data('id'),
        storySelector = '#story-text-'+ storyId;
    $(storySelector).removeClass('shorten-story');
  });
}
