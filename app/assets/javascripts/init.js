ARBOR = {
  common: {
    init: function() {
      $(function() {
        $(document).foundation();
      });
    }
  },
  user_stories:{},
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
    $rightContent   = $('.right-app-content'),
     projectsBar    = $sideBar.find('.sidebar-project-list'),
     toolBar        = $sideBar.find('.toolbar'),
     toggleIcon     = $sideBar.find('.icon-arrow'),
     toggleBar      = $sideBar.find('.icon-arrow, .current-project, .my-projects'),
     projectName    = $sideBar.find('.current-project').html(),
     projectsList   = projectsBar.find('li').not(':first'),
     collapsedBar   = $sideBar.find('.collapse'),
     projectItem    = $currentProject.parent('li'),
     activeState    = 'active',
     collapsedState = 'collapsed',
     fullState      = 'full';

// Add selected styles to page anchor
$sideBar.find('.toolbar a').each(function() {
  if ($(this).attr('href')  ===  window.location.pathname) {
    $(this).parent().addClass('selected')
  }
});

$(document).ready(function() {
  UTIL.init();

  if ($('.alert-box').is(':visible')) {
    setTimeout(function () {
      $('.alert-box').fadeOut();
    }, 2000);
  }//if alert box is visible
});
