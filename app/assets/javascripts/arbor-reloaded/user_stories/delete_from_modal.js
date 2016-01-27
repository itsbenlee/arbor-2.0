var $selectedStories = [],
    $fullStories     = [],
    $deleteModal     = $('#story-delete-modal');

$deleteModal.on('opened.fndtn.reveal', function() {
  loadStories();
  displayStoriesOnModal();
  bindDelete();
  bindModalClose();
  customScroll();
});

function bindModalClose() {
  $('#story-delete-modal .close').click(function(){
    $deleteModal.foundation('reveal', 'close');
  });
}

function loadStories() {
  $storiesToDelete = $('.backlog-user-story input:checked');
  if ($storiesToDelete.length) {
    $storiesToDelete.each(function() {
      $selectedStories.push($(this).val());
      $fullStories.push($(this).siblings().clone());
    });
  }
}

function displayStoriesOnModal() {
  var storiesList = $('#stories-list');
  storiesList.remove('li');
  $.each($fullStories, function(index, currentStory){
    opt = $('<li></li>');
    opt.append(currentStory.children());
    storiesList.append(opt);
  });
}

function bindDelete() {
  $('.reveal-modal.open #delete_stories_submit').click(function(){
    deleteStoriesModal();
  });
}

function deleteStoriesModal() {
  var $project = $deleteModal.data('projectid');

  $.ajax({
    type: 'delete',
    url: $deleteModal.data('url'),
    data: { user_stories: $selectedStories, project_id: $project },

    success: function(response){
      if(response.success) {
        $deleteModal.foundation('reveal', 'close');
        location.reload();
      }
    },

    error: function(response){
      if(response.status === 422) {
        var $errors = $.parseJSON(response.responseText).errors;
        alert($errors );
      }
    }
  });
}
