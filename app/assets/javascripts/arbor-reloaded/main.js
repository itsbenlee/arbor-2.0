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
function pseudoClickOnLink(linkToClick) {
   window.location.href = linkToClick.attr('href');
}

// This is for avoid repeated bind, everytime needs to bind something call this, Butcher
function generalBinds() {
  if ($('.project-list').length) {
    displayActions();
    displayHideDelete();
    bindFavoriteIcon();
    setFavoriteState();
    bindProjectsFilter();
  }
  if ($('.backlog-story-list').length) {
    displayActions();
    displayHideDelete();
    storiesWidth();
    displayColorTags();
  }
}

function bindAutoReveal() {
  $('div[data-auto-reveal]').foundation('reveal', 'open');
  $('div[data-auto-reveal]').addClass('with-errors');
  $('#create-project-btn').click(function() {
    $('#project-modal').foundation('reveal', 'open');
  });
}

function customScroll() {
  var $target = $('.custom-scroll');

  if ($target.length) {
    $target.mCustomScrollbar({
      theme: 'dark',
      autoHideScrollbar: 'true'
    });
  }
}//custom scroll

function customScrollDestroy() {
  var $target = $('.custom-scroll');

  if ($target.length) {
    $target.mCustomScrollbar("destroy");
  }
}//custom scroll destroy

// this functions needs a HashTable as param and deals with the disabled prop, Ale
/**
 * @param {HashTable} elements The HashTable of elements to deal with
 * @param {boolean} elements The HashTable of elements to deal with
 */
function setDisabledState(elements, reversed) {
  $.each(elements.keys(), function( index, value ) {
    if (reversed) {
      $(value).prop('disabled', !elements.getItem(value));
    } else {
      $(value).prop('disabled', elements.getItem(value));
    }
  });
}

// this functions needs a HashTable as param and deals with the visible prop, Ale
/**
 * @param {HashTable} elements The HashTable of elements to deal with
 * @param {boolean} elements The HashTable of elements to deal with
 */
function setVisibleState(elements, reversed){
  $.each(elements.keys(), function( index, value ) {
    if (reversed) {
      if (elements.getItem(value)) {
        $(value).hide();
      } else {
        $(value).show();
      }
    } else {
      if (elements.getItem(value)) {
        $(value).show();
      } else {
        $(value).hide();
      }
    }
  });
}

$('#updates-popup .dismiss').click(function (event) {
  $('#updates-popup').hide();

  if (!$(event.target).is('.learn-more')) {
    event.preventDefault();
  }
});

$(document).on('click', '.new-updates .dismiss', function (event) {
  $(event.target).closest('.new-updates').removeClass('new-updates');

  $.post($(event.target).data('url'));
});

$('.show-updates-popup').click(function () {
  $('#updates-popup').toggle();
});
