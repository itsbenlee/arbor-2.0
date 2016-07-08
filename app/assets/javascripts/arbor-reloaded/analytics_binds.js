$(document).on('click', '#save-project', {}, function(event) {
  AnalyticsTracks.createProject();
});

$(document).on('submit', '#new_user_story', {}, function(event) {
  AnalyticsTracks.createUserStory();
});

$(document).on('click', '#copy_stories_submit', {}, function(event) {
  AnalyticsTracks.addUserStoryToProject();
});

$(document).on('click', '#export-as-pdf-estimation', {}, function(event) {
  AnalyticsTracks.pdfExport();
});

$(document).on('click', '#export-as-pdf', {}, function(event) {
  AnalyticsTracks.pdfExport();
});

$(document).on('click', '.white-block[data-example="true"]', {}, function(event) {
  AnalyticsTracks.openExampleProject();
});
