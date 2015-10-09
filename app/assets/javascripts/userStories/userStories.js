function UserStories() {
  var $userStoriesOnList    = $('li.user-story'),
      $userStoriesList      = $('ul.user-story-list'),
      $userStoryForm        = $('.user-story-edit-form'),
      $newUserStoryForm     = $('form#new_user_story'),
      $backlogSection       = $('section.backlog'),
      $userStoriesContainer = $('.user-stories-list-container'),
      $backlogPreloader     = $('.user-stories-preloader'),
      projectId             = $backlogSection.data('projectId');

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
    $.get(url, function(editForm) {
      $userStoryForm.html('');
      $userStoryForm.html(editForm);
      bindUserStoryEditForm();
      bindNewAcceptanceCriterion();
      bindNewConstraint();
      bindEditAcceptanceCriterion();
      bindEditConstraint();
      refreshStories();
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

  function hideBacklog() {
    $userStoriesContainer.hide();
    $backlogPreloader.show();
  }

  function showBacklog() {
    $backlogPreloader.hide();
    $userStoriesContainer.show();
  }

  function refreshBacklog() {
    $.get('backlog', function(backlogHTML) {
      $userStoriesContainer.html('');
      $userStoriesContainer.html(backlogHTML);
      $userStoriesOnList = $('li.user-story');
      $userStoriesList   = $('ul.user-story-list');
      bindUserStoriesEvents();
      bindSelectStoriesEvent();
      showBacklog();
    });
  }

  function editFormAjax(url, type, currentObject) {
    hideBacklog();

    $.ajax({
      type: type,
      url: url,
      data: currentObject,
      success: function (response) {
        if(response.success) {
          refreshBacklog();
          editUrl = response.data.edit_url
          displayStoryForm(editUrl);
        }
      }
    });
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

  function bindNewAcceptanceCriterion() {
    $newCriterionForm = $('.new_acceptance_criterion');

    $newCriterionForm.submit(function() {
      var url        = $(this).attr('action'),
          type       = $(this).attr('method'),
          acriterion = $(this).serialize();

      editFormAjax(url, type, acriterion);
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

  function bindNewConstraint() {
    $newConstraintForm = $('.new_constraint');

    $newConstraintForm.submit(function() {
      var url        = $(this).attr('action'),
          type       = $(this).attr('method'),
          constraint = $(this).serialize();

      editFormAjax(url, type, constraint);
      hideBacklog();
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
