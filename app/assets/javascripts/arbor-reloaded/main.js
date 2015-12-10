function editFormAjax(url, type, currentObject) {
  var deferred = $.Deferred();

  $.ajax({
    type: type,
    url: url,
    data: currentObject,
    success: function (response) {
      if(response.success) {
        editUrl = response.data.edit_url;
        var displayPromise = displayStoryForm(editUrl);
        displayPromise.done(function() {
          deferred.resolve();
        });
      }
    },
    error: function (response) {
      if(response.status === 422) {
        var $errors = $.parseJSON(response.responseText).errors,
            $errorsContainer = $('.user-story-component-error');
        if ($errorsContainer.text().indexOf($errors) < 0) $errorsContainer.append($errors);
        $errorsContainer.show();
        refreshBacklog();
      }
    }
  });
  return deferred;
}
