$(document).ready(function() {
  var archivedStories = $('.archived-user-stories');
  bind_restore_link();

  function bind_restore_link() {
    $('.restore-link').click(function() {
      $.ajax({
        url: $(this).attr('url'),
        type: 'put',
        data: { user_story: { archived: false } },
        success: function (response) {
          if(response.success) {
            refresh_archived_index();
          }
        }
      });
    });
  }

  function refresh_archived_index() {
    $.get('list_archived', function(indexHTML) {
      archivedStories.html('');
      archivedStories.html(indexHTML);
      bind_restore_link();
    });
  }
})
