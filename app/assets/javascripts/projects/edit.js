$(document).ready(function() {
  var $editProject     = $('#edit_project'),
      $projectData     = $('.show-project-data'),
      $editProjectForm = $('.edit-project-form');

  $editProject.click(function() {
    $projectData.hide();
    $editProjectForm.show();
  });

  new Projects();
});
