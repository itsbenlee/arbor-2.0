function collapsableContent() {
  var $trigger = $('#groups-list .toggle-content-btn');

  $trigger.on( "click", function(e) {
    e.preventDefault();
    e.stopPropagation();
    $(this).closest('.form-group-container').next().fadeToggle(400);
    $(this).toggleClass('active');
  });
}

function moveUpTheme() {
  $(document).on('click', '#groups-list .move-group.up', function(e) {
    e.preventDefault();
    e.stopPropagation();

    $this = $(this);
    if ($this.is('.move-group.up:not(:first)')) {
      var $groupDivider = $this.closest('.group-divider');
      var $prev = $groupDivider.prev();
      $prev.before($groupDivider);

      makePatchAJAXCall($this.data('url'))
    }
  });
}

function moveDownTheme() {
  $(document).on('click', '#groups-list .move-group.down', function(e) {
    e.preventDefault();
    e.stopPropagation();

    $this = $(this);
    if ($this.is('.move-group.down:not(:last)')) {
      var $groupDivider = $this.closest('.group-divider');
      var $next = $groupDivider.next();
      $next.after($groupDivider);

      makePatchAJAXCall($this.data('url'))
    }
  });
}

function toggleStatusTheme() {
  $(document).on('click', '#groups-list .status-btn', function(e) {
    e.preventDefault();
    e.stopPropagation();

    makePatchAJAXCall($(this).data('url'));
  });
}

var makePatchAJAXCall = function(url, success, error) {
  $.ajax({
    type: 'PATCH',
    url: url,
    success: success,
    error: error
  });
}
