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

$(document).bind('formNotification.error', function (event, text) {
  var $div = $('<div></div>').text(text).addClass("alert-box error");

  $('<a></a>').attr('href', '#').addClass('close').text('×').appendTo($div);
  $div.insertAfter('.secondary-nav').show();

  setTimeout(function () {
    $div.fadeOut();
  }, 2000);
});

$(document).ready(function() {
  UTIL.init();

  if ($('.alert-box').is(':visible')) {
    setTimeout(function () {
      $('.alert-box').fadeOut();
    }, 2000);
  }//if alert box is visible
});
