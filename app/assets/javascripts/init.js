ARBOR = {
  common: {
    init: function() {
      $(function() {
        $(document).foundation();
      });
    }
  },
  projects: {},
  canvases: {},
  hypotheses: {},
  user_stories:{}
};

UTIL = {
  exec: function(controller, action) {
    var namespace = ARBOR,
        action = (action === undefined) ? 'init' : action;

    if (controller !== '' && namespace[controller] &&
        typeof namespace[controller][action] == 'function') {
      namespace[controller][action]();
    }
  },

  init: function() {
    var body = document.body,
        controller = body.getAttribute('data-controller'),
        action = body.getAttribute('data-action');

    UTIL.exec('common');
    UTIL.exec(controller);
    UTIL.exec(controller, action);
  }
};

var projectsBar = $('#sidebar .sidebar-project-list'),
    toolBar     = $('#sidebar .toolbar'),
    toggleIcon  = $('#sidebar .icon-arrow'),
    activeState = 'active';


$('#sidebar a').each(function() {
  if ($(this).attr('href')  ===  window.location.pathname) {
    $(this).parent().addClass('selected')
  }
});

function slideSidebarToogle() {

  if (toolBar.is(':visible')) {
    toggleIcon.addClass(activeState);
    toolBar.addClass(activeState).delay(500).hide(1);
    projectsBar.addClass(activeState)
  } else {
    toggleIcon.removeClass(activeState);
    toolBar.show(1).removeClass(activeState);
    projectsBar.removeClass(activeState)
  }
}

$('.icon-arrow').bind('click', function(event) {

  if (toolBar.length) {
    slideSidebarToogle()
  } else {
    toggleIcon.toggleClass(activeState);
    projectsBar.toggleClass(activeState)
  }

  event.preventDefault();
});

$('select#user_story_priority').on('change', function() {
  $(this).closest('form#new_user_story').find('.user-story-priority').text(this.value);
});

$('#log-modal').on('opened.fndtn.reveal', function() {
  var $modal_height = $('#log-modal').height();

  $('#log-modal').on('scroll', function() {
    var active_pages = $('#log .active.log-page').size()
        inactive_pages = $('#log .inactive.log-page').size(),
        number_pages = active_pages + inactive_pages,
        pages_left = number_pages - inactive_pages > 0,
        log_height = $('#log').height(),
        scroll_from_top = $('#log-modal').scrollTop();

    if (pages_left && scroll_from_top > log_height - $modal_height ) {
      $('#log .inactive.log-page').first().toggleClass('active inactive');
    }
  });
});

$(document).on('page:change', UTIL.init);
