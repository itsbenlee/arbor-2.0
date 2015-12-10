function ajaxCall(url, type, currentObject) {
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

// for security reasons javascript doesn't allow the click event, this simulates it, Ale
function pseudoClickOnLink(linkToClick){
   window.location.href = linkToClick.attr('href');
}
