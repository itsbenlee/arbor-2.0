var $export_trello = $('#trello_export_link');

$('#trello-export-submit').click(function() {
  $('.trello-export-success').html('');
  if ($('#board_id').length > 0) {
    $('#select-board-form').submit();
  }
  else {
    var export_type = document.getElementById('export_type').value,
        token = $(this).data('token'),
        url = $(this).data('url');

    token == null ? authorizeTrello(export_type, url) : exportToTrello(token, export_type, url);
  }
});

function authorizeTrello(export_type, url) {
  Trello.authorize({
    name: "Arbor",
    type: "popup",
    interactive: true,
    expiration: "never",
    persist: false,
    success: function () {
      var token = Trello.token();
      exportToTrello(token, export_type, url);
    },
    scope: { write: true, read: true },
  });
}

function exportToTrello(token, export_type, url) {
  if (export_type === 'new_board') {
    ajaxCallNewBoard(token, url);
  }
  else if (export_type === 'existing_board') {
    ajaxCallBoards(token, url);
  }
}

function ajaxCallNewBoard(token, url) {
  $.ajax({
    url: url,
    method: 'POST',
    data:{ token: token },
    success: function(response) {
      if (response.success) {
        $('.trello-export-success').html(response.data.message);
      }
    },
    error: function(response) {
      if($.parseJSON(response.responseText).data.token_error) {
        var export_type = document.getElementById('export_type').value;
        authorizeTrello(export_type, url);
      }
      else {
        $('.trello-export-error').html('There was an error exporting your project to Trello. Please try again later');
      }
    }
  });
}

hideSuccessMessage();
buttonDisable();

function hideSuccessMessage() {
  var $trelloModal = $('#trello-modal');

  $trelloModal.on('close.fndtn.reveal', function() {
    $('.trello-export-success').html('');
  });
}

function ajaxCallBoards(token, url) {
  $.ajax({
    url: url,
    method: 'GET',
    data:{ token: token },
    success: function(response) {
      $('.select-board-list').html(response);
      $('.select-board-list').removeClass('hide');
    }
  });
}

function buttonDisable() {
  $( document ).ajaxStart(function() {
    $('#trello-export-submit').attr("disabled", true);
  });
  $(document).ajaxComplete(function () {
    $('#trello-export-submit').attr("disabled", false);
  });
}
