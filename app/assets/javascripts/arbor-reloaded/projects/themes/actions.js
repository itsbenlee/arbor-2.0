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
  $('#groups-list .move-group.up').on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();

    $this = $(this);
    if ($this.is('.move-group.up:not(:first)')) {
      var $groupDivider = $this.closest('.group-divider');
      var $prev = $groupDivider.prev();
      $prev.before($groupDivider);

      makeAJAXCall($this.data('url'))
    }
  });
}

function moveDownTheme() {
  $('#groups-list .move-group.down').on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();

    $this = $(this);
    if ($this.is('.move-group.down:not(:last)')) {
      var $groupDivider = $this.closest('.group-divider');
      var $next = $groupDivider.next();
      $next.after($groupDivider);

      makeAJAXCall($this.data('url'))
    }
  });
}

function toggleStatusTheme() {
  $('#groups-list .status-btn').on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();

    // debugger;
    makeAJAXCall($(this).data('url'), function(response) {
      console.log(response);
    });
  });
}

var makeAJAXCall = function(url, success, error) {
  $.ajax({
    type: 'PATCH',
    url: url,
    success: success,
    error: error
  });
}
