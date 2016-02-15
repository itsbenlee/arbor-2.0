function bindFavoriteIcon() {
  $('.favorite-link').click(function() {
    var project = {
          project: { favorite: !($(this).data('favorite')) }
        },
        url = $(this).data('url'),
        type = 'put';
    projectAjaxCall(url, type, project);
    return false;
  });
}

function setFavoriteState() {
  $('.favorite-link').each(function(index, el) {
    if ($(el).data('favorite')) {
      $(this).addClass('is-favorite');
    }
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
  });
}

function bindProjectsFilter() {
  $('#projects-filter').click(function() {
    $.ajax({
      dataType: 'json',
      method: 'GET',
      url: $(this).data('url'),
      success: function (response) {
        if(response.success) {
          projects = response.data.projects;
          filterProjects(projects);
        }
      }
    });
  });
}

function filterProjects(projects) {
  $('#projects-filter').autocomplete({
    source: projects,
    focus: function (event, ui) {
      $(event.target).val(ui.item.label);
      return false;
    },
    select: function (event, ui) {
      $(event.target).val(ui.item.label);
      window.location = ui.item.value;
      return false;
    }
  });
}
