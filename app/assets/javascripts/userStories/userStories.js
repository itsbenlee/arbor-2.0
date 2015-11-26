function UserStories() {
  var $userStoriesOnList    = $('li.user-story'),
      $userStoriesList      = $('ul.user-story-list'),
      $userStoryForm        = $('.user-story-edit-form'),
      $newUserStoryForm     = $('form#new_user_story'),
      $backlogSection       = $('section.backlog'),
      $userStoriesContainer = $('.user-stories-list-container'),
      $backlogPreloader     = $('.user-stories-preloader'),
      projectId             = $backlogSection.data('projectId'),
      selectedTags          = [],
      projectTags           = [],
      $criterionsOnList     = $('li.criterion'),
      $criterionsList       = $('ul.criterions-list');

  function filterByTags(tags) {
    $('#stories-filter').autocomplete({
      source: function(request, response) {
          var matcher = new RegExp(
              '^' + $.ui.autocomplete.escapeRegex( request.term ), 'i' );
          response( $.grep( tags, function( item ){
              return matcher.test( item );
          }));
      },
      minLength: 0,
      autoFocus: true
    });

    $('#stories-filter').autocomplete( 'search', '' );
  }

  function displayAppliedTags() {
    var template = $('#tagTemplate').html(),
        tags = { 'tags': selectedTags },
        html = Mustache.to_html(template, tags);

    $('#tag-list').html(html);
    $('.applied-filters').show();
  }

  function bindRemoveTag() {
    $('.applied-tag').click(function(e) {
      if (e.shiftKey) return;

      var tag_to_remove = $(this).text().trim(),
          index = selectedTags.indexOf(tag_to_remove);
      if (index > -1) {
          selectedTags.splice(index, 1);
      }
      if (selectedTags.length > 0) {
        getUserStoriesByTags();
      }
      else {
        refreshBacklog();
      }
    });
  }

  function getUserStoriesByTags() {
    $.ajax({
      dataType: 'html',
      method: 'GET',
      url: 'tags/filter',
      data: { tag_names: selectedTags },
      success: function (response) {
        $userStoriesContainer.html('');
        $userStoriesContainer.html(response);
        $userStoriesOnList = $('li.user-story');
        $userStoriesList   = $('ul.user-story-list');
        bindUserStoriesEvents();
        bindSelectStoriesEvent();
        bindTagFilter();
        bindTagCheckboxes();
        bindSubmitTag();
        displayAppliedTags();
        bindRemoveTag();
      }
    });
  }

  function bindSubmitTag() {
    $('#stories-filter').bind('keypress', function(e) {
      if(e.keyCode === 13) {
        var current_val = $(this).val(),
            project_tag_index = projectTags.indexOf(current_val),
            selected_tag_index = selectedTags.indexOf(current_val);
        if(project_tag_index > -1 && selected_tag_index === -1 ) {
          var tag_name = current_val;
          selectedTags.push(tag_name);
          getUserStoriesByTags();
        }
      }
    });
  }

  bindSubmitTag();
  bindTagFilter();

  function bindTagFilter() {
    $('#stories-filter').click(function() {
      $.ajax({
        dataType: 'json',
        method: 'GET',
        url: 'tags/index',
        data: $(this).data('project-id'),
        success: function (response) {
          if(response.success) {
            projectTags = response.data.tags;
            filterByTags(projectTags);
          }
        }
      });
    });
  }

  function setBacklogOrder() {
    var newOrder = { stories: [] },
        $updatedUserStoriesOnList = $('li.user-story');

    $.each($updatedUserStoriesOnList, function(index) {
      var story = { id: $(this).data('id'), backlog_order: index + 1 };
      newOrder.stories.push(story);
    });

    return newOrder;
  }

  function displayStoryForm(url) {
    return $.get(url, function(editForm) {
      $userStoryForm.html('');
      $userStoryForm.html(editForm);
      bindUserStoryEditForm();
      bindReorderCriterionsEvents();
      bindReorderConstraintEvents();
      bindNewAcceptanceCriterion();
      bindNewConstraint();
      bindEditAcceptanceCriterion();
      bindEditConstraint();
      bindTagCheckboxes();
      bindNewTag();
      bindDeleteTag();
      bindNewComment();
      refreshStories();
      bindAcceptanceCriterionFadeOut();
      bindConstraintFadeOut();
    });
  }

  function bindUserStoriesEvents() {
    $userStoriesOnList.click(function() {
      var url = $(this).data('url');
      $userStoriesOnList.removeClass('selected');
      $(this).addClass('selected');
      displayStoryForm(url);
    });

    $userStoriesList.sortable({
      connectWith: '.user-story-list',
      stop: function() {
        var newOrder = setBacklogOrder(),
            url = $userStoriesList.data('url');

        $.ajax({
          url: url,
          dataType: 'json',
          method: 'PUT',
          data: { stories: newOrder.stories }
        });
      }
    });
  }


  function bindReorderCriterionsEvents() {
    $('li.criterion').click(function() {
      $('li.criterion').removeClass('selected');
      $(this).addClass('selected');
    });

    $('ul.criterions-list').sortable({
      connectWith: '.criterions-list',
      stop: function() {
        var newCriterionsOrder = setCriterionsOrder(),
            url = $('ul.criterions-list').data('url');
            userStory = $('ul.criterions-list').data('user-story');
        $.ajax({
          url: url,
          dataType: 'json',
          method: 'PUT',
          data: { criterions: newCriterionsOrder.criterions, user_story: userStory }
        });
      }
    });
  }

  function setCriterionsOrder() {
    var newCriterionsOrder = { criterions: [] },
        $updatedCriterionsOnList = $('li.criterion');

    $.each($updatedCriterionsOnList, function(index) {
      var criterion = { id: $(this).data('id'), criterion_order: index + 1 };
      newCriterionsOrder.criterions.push(criterion);
    });

    return newCriterionsOrder;
  }

  function bindReorderConstraintEvents() {
    $('li.constraint').click(function() {
      $('li.constraint').removeClass('selected');
      $(this).addClass('selected');
    });

    $('ul.constraints-list').sortable({
      connectWith: '.constraints-list',
      stop: function() {
        var newConstraintsOrder = setConstraintsOrder(),
            url = $('ul.constraints-list').data('url');
            userStory = $('ul.criterions-list').data('user-story');

        $.ajax({
          url: url,
          dataType: 'json',
          method: 'PUT',
          data: { constraints: newConstraintsOrder.constraints, user_story: userStory }
        });
      }
    });
  }

  function setConstraintsOrder() {
    var newConstraintsOrder = { constraints: [] },
        $updatedConstraintsOnList = $('li.constraint');

    $.each($updatedConstraintsOnList, function(index) {
      var constraint = { id: $(this).data('id'), constraint_order: index + 1 };
      newConstraintsOrder.constraints.push(constraint);
    });

    return newConstraintsOrder;
  }

  function hideBacklog() {
    $userStoriesContainer.hide();
    $backlogPreloader.show();
  }

  function showBacklog() {
    $backlogPreloader.hide();
    $userStoriesContainer.show();
  }

  function refreshBacklog(editUrl) {
    $.get('list_backlog', function(backlogHTML) {
      $userStoriesContainer.html('');
      $userStoriesContainer.html(backlogHTML);
      $userStoriesOnList = $('li.user-story');
      $userStoriesList   = $('ul.user-story-list');
      bindUserStoriesEvents();
      bindSelectStoriesEvent();
      bindTagCheckboxes();
      bindTagFilter();
      bindSubmitTag();
      showBacklog();
      bindRemoveTag();
      if (editUrl !== undefined) {
        $userStoriesOnList.removeClass('selected');
        $("[data-url='" + editUrl + "']").addClass('selected');
      }
      fixArticlesForRolesOnBacklog();
    });
  }

  function editFormAjax(url, type, currentObject) {
    hideBacklog();
    var deferred = $.Deferred();

    $.ajax({
      type: type,
      url: url,
      data: currentObject,
      success: function (response) {
        if(response.success) {
          editUrl = response.data.edit_url;
          refreshBacklog(editUrl);
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
          $errorsContainer.append($errors);
          $errorsContainer.show();
          refreshBacklog();
        }
      }
    });
    return deferred;
  }

  bindUserStoriesEvents();
  $newUserStoryForm.submit(function() {
    var url       = $(this).attr('action'),
        type      = $(this).attr('method'),
        userStory = $(this).serialize();

    $userStoryForm.removeClass('full-width');
    editFormAjax(url, type, userStory);
    return false;
  });

  function bindNewTag() {
    $newTagForm = $('.new_tag');

    $newTagForm.submit(function() {
      var url  = $(this).attr('action'),
          type = $(this).attr('method'),
          tag  = $(this).serialize();

      editFormAjax(url, type, tag);
      return false;
    });
  }

  function bindDeleteTag() {
    $('.user-story-tag').click(function(e) {
      if (e.shiftKey) {
        e.preventDefault();
        tagCheckbox = this.getElementsByTagName('input')[0];
        tagId = tagCheckbox.value
        tagCheckbox.checked = false;
        userStory = $('.user-story-tag').data('user-story');

        $.ajax({
          dataType: 'json',
          method: 'GET',
          url: 'tag/delete',
          data: {tag_id: tagId, user_story: userStory},
          success: function (response) {
            if(response.success) {
              url = '/backlog/' + userStory + '/edit';
              displayStoryForm(url);
              refreshBacklog(url);
              var displayPromise = displayStoryForm(url);
              displayPromise.done(function() {
                deferred.resolve();
              });
            }
          },
          error: function (response) {
            if(response.status === 422) {
              var $errors = $.parseJSON(response.responseText).errors,
                  $errorsContainer = $('.user-story-component-error');
              $errorsContainer.append($errors);
              $errorsContainer.show();
              refreshBacklog();
            }
          }
        });
      }
    });
  }


  function bindNewComment() {
    $newCommentForm = $('.new_comment');

    $newCommentForm.submit(function() {
      var url     = $(this).attr('action'),
          type    = $(this).attr('method'),
          comment = $(this).serialize();

      editFormAjax(url, type, comment);
      return false;
    });
  }


  function bindNewAcceptanceCriterion() {
    $newCriterionForm = $('.new_acceptance_criterion');

    $newCriterionForm.submit(function() {
      var url        = $(this).attr('action'),
          type       = $(this).attr('method'),
          acriterion = $(this).serialize();

      var deferred = editFormAjax(url, type, acriterion);
      deferred.done(function() {
        $('.new-criterion-field textarea').focus();
      });
      return false;
    });
  }

  function bindEditAcceptanceCriterion() {
    $editCriterionForm = $('.edit_acceptance_criterion');

    $editCriterionForm.submit(function() {
      var url        = $(this).attr('action'),
          type       = $(this).attr('method'),
          acriterion = $(this).serialize();

      editFormAjax(url, type, acriterion);
      return false;
    });
  }

  function bindNewConstraint() {
    $newConstraintForm = $('.new_constraint');

    $newConstraintForm.submit(function() {
      var url        = $(this).attr('action'),
          type       = $(this).attr('method'),
          constraint = $(this).serialize();

      var deferred = editFormAjax(url, type, constraint);
      deferred.done(function() {
        $('.new-constraint-field textarea').focus();
      });
      return false;
    });
  }

  function bindEditConstraint() {
    $editConstraintForm = $('.edit_constraint');

    $editConstraintForm.submit(function() {
      var url        = $(this).attr('action'),
          type       = $(this).attr('method'),
          constraint = $(this).serialize();

      editFormAjax(url, type, constraint);
      return false;
    });
  }

  function bindUserStoryEditForm() {
    $editUserStoryForm = $('form.edit-story.edit_user_story');
    $editUserStoryForm.submit(function() {
      var url       = $(this).attr('action'),
          type      = $(this).attr('method'),
          userStory = $(this).serialize();

      editFormAjax(url, type, userStory);
      return false;
    });
  }

  function refreshStories() {
    $('.user-story-edit-form .user-story-input input:text').each(function() {
      var $this  = $(this),
          $span  = $this.parent().find('span'),
          $value = $this.val;

      if ($value) {
        $this.select();
        $this.hide();
        $span.html($this.val());
      }

      // correct articles when saved client story get clicked on backlog, Ale
      prependGramaticallyCorrectArticle(this);
      // bind key events for the new edit form to be created, Ale
      $('.edit-story .row #user_story_role.role').on('keydown keyup', function(e) {
        prependGramaticallyCorrectArticle(this);
      });
    });
  }

  function bindSelectStoriesEvent() {
    var $selectStoriesLnk = $('a#select_stories_lnk');

    $selectStoriesLnk.click(function() {
      var $copyStoriesLnk          = $('a#copy_stories_lnk'),
          $copyStoriesChkContainer = $('.copy-story-check-box');

      $(this).hide();
      $copyStoriesLnk.show();
      $copyStoriesChkContainer.show();
      return false;
    });
  }

  bindSelectStoriesEvent();

  function bindTagCheckboxes() {
    $('.user-story-tag').change(function() {
      var $editForm = $(this).parent();
      $editForm.submit();
    });
  }

  function bindConstraintFadeOut() {
    $('a#delete_constraint').bind('ajax:success', function() {
      $(this).parents('.delete-constraint-edit').fadeOut();
    });
  }

  function bindAcceptanceCriterionFadeOut() {
    $('a#delete_acceptance_criterion').bind('ajax:success', function() {
      $(this).parents('.delete-acceptance-criterion-edit').fadeOut();
    });
  }
}

fullWidthForm();

function fullWidthForm() {
  if (!$('.user-story-list').is(':visible')) {
    $('.user-story-edit-form').addClass('full-width');
  }
}

$(document).on('click', 'span', function () {
  var $span  = $('.user-story-edit-form .user-story-input span'),
      $input = $('.user-story-edit-form .user-story-input input:text');

  $span.hide();
  $input.show();
  $(this).next('input:text').focus();
  dynamicInput();
});

$(document).on('blur', '.user-story-edit-form .user-story-input input:text', function() {
  var $this  = $(this),
      $span  = $this.parent().find('span');

  if (!$this.val() == '') {
    $span.show().html($this.val());
    $this.hide();
  }
});

function setDynamicClass(input) {
  var $input  = $(input);

  if (!$input.val() == '') {
    $input.addClass('dynamic');
  } else {
    $input.removeClass('dynamic');
  }
}

$(document).on('keyup', '.user-story-edit-form .user-story-input input:text', function() {
  setDynamicClass(this);
});

$(document).on('focus', '.user-story-edit-form .user-story-input input:text', function() {
  setDynamicClass(this);
});

dynamicInput();

function dynamicInput() {
  var AutosizeInputOptions = (function() {
    function AutosizeInputOptions(space) {
      if (typeof space === 'undefined') { space = 30; }
      this.space = space;
    }

    return AutosizeInputOptions;
  })();

  dynamicInput.AutosizeInputOptions = AutosizeInputOptions;

  var AutosizeInput = (function() {
    function AutosizeInput(input, options) {
      var _this = this;
      this._input = $(input);
      this._options = $.extend({}, AutosizeInput.getDefaultOptions(), options);

      this._mirror = $('<span style = "position: absolute; top: -999px; left: 0; white-space: pre;" />');

      $.each(['fontFamily', 'fontSize', 'fontWeight', 'fontStyle', 'letterSpacing', 'textTransform', 'wordSpacing', 'textIndent'], function (i, val) {
        _this._mirror[0].style[val] = _this._input.css(val);
      });
      $('body').append(this._mirror);

      this._input.on('keydown keyup input propertychange change', function(e) {
        //mock html5 validation if safari, Ale
        if(is_safari && e.keyCode === 13 ) {
          preSubmitForm(this);
        }

        _this.update();
      });

      (function () {
        _this.update();
      })();

    }

    AutosizeInput.prototype.getOptions = function() {
      return this._options;
    };

    AutosizeInput.prototype.update = function() {
      var value = this._input.val() || '';

      if (value === this._mirror.text()) {
        return;
      }

      this._mirror.text(value);

      var newWidth = this._mirror.width() + this._options.space;

      this._input.width(newWidth);
    };

    AutosizeInput.getDefaultOptions = function() {};

    AutosizeInput.getInstanceKey = function() {
      return 'autosizeInputInstance';
    };

    AutosizeInput._defaultOptions = new AutosizeInputOptions();
    return AutosizeInput;
  })();

  dynamicInput.AutosizeInput = AutosizeInput;

  (function($) {
    var pluginDataAttributeName = 'autosize-input';
    var validTypes = ['text', 'password', 'search', 'url', 'tel', 'email', 'number'];

    $(document).on('focus', ':input', function() {
      $(this).attr('autocomplete', 'off');
    });

    $.fn.autosizeInput = function (options) {
      return this.each(function () {

        if (!(this.tagName == 'INPUT' && $.inArray(this.type, validTypes) > -1)) {
          return;
        }

        var $this = $(this);

        if (!$this.data(dynamicInput.AutosizeInput.getInstanceKey())) {
          if (options == undefined) {
            options = $this.data(pluginDataAttributeName);
          }

          $this.data(dynamicInput.AutosizeInput.getInstanceKey(), new dynamicInput.AutosizeInput(this, options));
        }
      });
    };

    $(function () {
      $('input[data-' + pluginDataAttributeName + ']').autosizeInput();
    });
  })($);
}

// html5 validation copycat, Ale
function preSubmitForm(obj) {
  var requiredFields = $('#'+obj.form.id).find('select, textarea, input').serializeArray();
      isItOk = true;
      message = 'Please complete all the fields';

  $.each(requiredFields, function(i, field) {
    if (!field.value)
      isItOk = false;
  });

  if (isItOk) {
    $(obj.form).submit();
  } else {
    alert(message);
  }
}
