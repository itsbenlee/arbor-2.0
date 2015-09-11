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

var $sideBar        = $('#sidebar'),
    $currentProject = $('.current-project'),
     projectsBar    = $sideBar.find('.sidebar-project-list'),
     toolBar        = $sideBar.find('.toolbar'),
     toggleIcon     = $sideBar.find('.icon-arrow'),
     toggleBar      = $sideBar.find('.icon-arrow, .current-project, .my-projects'),
     projectName    = $sideBar.find('.current-project').html(),
     projectItem    = $currentProject.parent('li'),
     activeState    = 'active';


$sideBar.find('.toolbar a').each(function() {
  if ($(this).attr('href')  ===  window.location.pathname) {
    $(this).parent().addClass('selected')
  }
});

function slideSidebarToogle() {

  if (toolBar.is(':visible')) {
    $currentProject.html('My projects').removeClass(activeState);
    toggleIcon.addClass(activeState);
    toolBar.addClass(activeState).delay(500).hide(1);
    projectsBar.addClass(activeState)
  } else {
    $currentProject.html(projectName).addClass(activeState);
    toggleIcon.removeClass(activeState);
    toolBar.show(1).removeClass(activeState);
    projectsBar.removeClass(activeState)
  }
}

if (toolBar.length) {
  toggleBar.bind('click', function(event) {
    slideSidebarToogle()

    event.preventDefault();
  });
} else {
  toggleIcon.addClass(activeState);
  toggleBar.bind('click', function(event) {
    toggleIcon.toggleClass(activeState);
    projectsBar.toggleClass(activeState)

    event.preventDefault();
  });
}

$('select#user_story_priority').on('change', function() {
  $(this).closest('form#new_user_story').find('.user-story-priority').text(this.value);
});

$(document).on('page:change', UTIL.init);
