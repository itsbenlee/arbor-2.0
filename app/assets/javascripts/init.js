ARBOR = {
  common: {
    init: function() {
      $(function() {
        $(document).foundation();
      });
    }
  },
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

// Show/hide projects list
function slideSidebarToogle() {
  if (toolBar.is(':visible')) {
    hideToolbar();
  } else {
    showToolbar();
  }
}

function hideToolbar() {
  $currentProject.html('My projects').removeClass(activeState); // Change Current Project Name for 'My projects'
  toggleIcon.addClass(activeState); // Rotate arrow
  toolBar.addClass(activeState).hide(); // Hide toolbar
  projectsBar.addClass(activeState); // Add active state
  projectsList.delay(200).fadeIn(); // Show project list
}

function showToolbar() {
  $currentProject.html(projectName).addClass(activeState); // Change Back Current Project Name
  toggleIcon.removeClass(activeState); // Rotate arrow
  toolBar.delay(200).fadeIn().removeClass(activeState); // Show toolbar
  projectsBar.removeClass(activeState); // Remove active state
  projectsList.fadeOut(); // Hide project list
}

function toggleCollapseState() {
  $sideBar.toggleClass(collapsedState); // Toogle collapse state
  $rightContent.toggleClass(fullState); // Toogle resize right content
}

// Collapse/uncollapse sidebar
function collapseSidebar() {

  // If browser window < than media queries large...
  if (!matchMedia(Foundation.media_queries.large).matches) {

    // If bar is collapsed...
    if (collapsedBar.hasClass(collapsedState)) {
      toggleCollapseState();

    // If bar is uncollapsed...
    } else {
      $sideBar.addClass(collapsedState); // Collapse sidebar
      $rightContent.addClass(fullState); // Resize right content

      // If toolbar is not visible...
      if (!toolBar.is(':visible')) {
        showToolbar();
      }
    }
  }
}

if (toolBar.length) {
  projectsList.hide(); // Hide project list

  // On arrow icon click
  toggleBar.bind('click', function(event) {
    slideSidebarToogle();

    // Uncollapse sidebar
    $sideBar.removeClass(collapsedState);
    $rightContent.removeClass(fullState);

    event.preventDefault();
  });

  // On collapse icon click
  collapsedBar.bind('click', function(event) {

    // Collapse sidebar
    toggleCollapseState();

    // Hide project list
    showToolbar();

    event.preventDefault();
  });

// If toolbar is not present
} else {
  collapsedBar.hide();  // Don't show collapse icon
  toggleIcon.addClass(activeState); // Rotate arrow

  // On arrow click
  toggleBar.bind('click', function(event) {
    toggleIcon.toggleClass(activeState); // Rotate arrow
    projectsBar.toggleClass(activeState); // Remove active state
    projectsBar.find('li').not(':first').fadeToggle(); // Hide project list

    event.preventDefault();
  });
}

collapseSidebar()

// On resize ejecute function
$(window).resize(collapseSidebar);


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

$('.hypothesis input')
  .focus(function() {
    $(this).closest('.row').addClass('editing');
  })

  .blur(function() {
    $(this).closest('.row').removeClass('editing');
});

$(document).ready(function() {
  UTIL.init();
});

