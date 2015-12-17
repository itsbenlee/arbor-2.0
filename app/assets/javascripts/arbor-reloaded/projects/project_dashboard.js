function bindFavoriteIcon() {
  $('.favorite-link').click(function() {
    var project = {
          project: { favorite: !($(this).data('favorite')) }
        }
        url = $(this).data('url'),
        type  = 'put';

    projectAjaxCall(url, type, project);
    return false;
  });
}

function projectAjaxCall(url, type, currentObject) {
  var deferred = $.Deferred();

  $.ajax({
    type: type,
    url: url,
    data: currentObject,
    success: function (response) {
      if(response.success) {
        return_url = response.data.return_url;
        var displayPromise = displayProjectsView(return_url);
        displayPromise.done(function() {
          deferred.resolve();
        });
      }
    },
    error: function (response) {
      if(response.status === 422) {
        var $errors = $.parseJSON(response.responseText).errors,
            //TODO use a generic errors container, like an alert, Ale
            $errorsContainer = $('.user-story-component-error');
        if ($errorsContainer.text().indexOf($errors) < 0) $errorsContainer.append($errors);
        $errorsContainer.show();
        refreshBacklog();
      }
    }
  });
  return deferred;
}

function displayProjectsView(url) {
  return $.get(url, function(indexProject) {
    $('.project-list').html(indexProject);
    generalBinds();
  })
}
