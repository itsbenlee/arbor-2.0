var $export_trello = $('#trello_export_link');

$export_trello.click(function() {
  Trello.authorize({
    name: "Arbor",
    type: "popup",
    interactive: true,
    expiration: "never",
    persist: false,
    success: function () { onAuthorizeSuccessful(); },
    scope: { write: true, read: true },
  });
});

function onAuthorizeSuccessful() {
  var token = Trello.token();
  window.location.replace("hypotheses/export/trello?token=" + token);
}
