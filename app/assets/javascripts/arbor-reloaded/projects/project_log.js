$( document ).ready(function() {
  if ($("#log").length > 0) {
    displayInitialWhenNoAvatarOnLogLine();
  }
});

// TODO refactor this and use the same function as in porject members,
// maybe create a common-poject-js and leave it there, Ale
function displayInitialWhenNoAvatarOnLogLine() {
  $('.log-entry').has('span.person').each(function(index, currentValue) {
    var initial = $(currentValue).find('#person-name').text().trim().substring(0,1);
    $(currentValue).find('#avatar-circle').text(initial.toUpperCase());
  });
}
