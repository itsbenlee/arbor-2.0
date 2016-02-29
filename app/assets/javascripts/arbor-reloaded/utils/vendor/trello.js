var $export_trello          = $('#trello_export_link'),
    $export_trello_board    = $('#trello_export_existing_board_link');

authorizeTrello();
authorizedTrelloExport();
authorizedTrelloExportBoard();

function authorizeTrello() {
  $('#authorize-arbor-on-trello').click(function() {
    var url = $(this).data('url');
    Trello.authorize({
      name: "Arbor",
      type: "popup",
      interactive: true,
      expiration: "never",
      persist: false,
      success: function () {
        var token = Trello.token();
        authorizeAjaxCall(token, url);
      },
      scope: { write: true, read: true },
    });
  });
}

function authorizeAjaxCall(token, url) {
  $.ajax({
    url: url,
    method: 'GET',
    data:{ token: token },
    success: function(response) {
      $('.authorized-trello-links').html(response);
      authorizedTrelloExport();
      authorizedTrelloExportBoard();
    }
  });
}

function authorizedTrelloExport() {
  $('#trello_export_authorized').click(function() {
    var token = $(this).data('token'),
        url = $(this).data('url');
    ajaxCallNewBoard(token, url);
  });
}

$export_trello.click(function() {
  var url = $(this).data('url');
  Trello.authorize({
    name: "Arbor",
    type: "popup",
    interactive: true,
    expiration: "never",
    persist: false,
    success: function () {
      var token = Trello.token();
      ajaxCallNewBoard(token, url);
    },
    scope: { write: true, read: true },
  });
});

function ajaxCallNewBoard(token, url) {
  $.ajax({
    url: url,
    method: 'POST',
    data:{ token: token },
    success: function(response) {
      $('.trello-export-result').html(response.data.message);
    },
    error: function(response) {
      var authorizeLinks = $('.trello-authorize-link');
      if($.parseJSON(response.responseText).data.token_error) {
        authorizeLinks.removeClass('hide');
        authorizeTrello();
      }
      else {
        $('.trello-export-result').html('There was an error exporting your project to Trello. Please try again later');
      }
    }
  });
}

function authorizedTrelloExportBoard() {
  $('#trello_export_board_authorized').click(function() {
    var token = $(this).data('token'),
        url = $(this).data('url');
    ajaxCallBoards(token, url)
  });
}

$export_trello_board.click(function() {
  var url = $(this).data('url');
  Trello.authorize({
    name: "Arbor",
    type: "popup",
    interactive: true,
    expiration: "never",
    persist: false,
    success: function () {
      var token = Trello.token();
      ajaxCallBoards(token, url);
    },
    scope: { write: true, read: true },
  });
});

function ajaxCallBoards(token, url) {
  $.ajax({
    url: url,
    method: 'GET',
    data:{ token: token },
    success: function(response) {
      $('.select-board-list').html(response);
      $('.select-board-list').removeClass('hide');
      authorizeTrello();
    }
  });
}
