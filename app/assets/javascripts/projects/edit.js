$(document).ready(function() {
 // Unecessary if not a modal window, TODO: refactor to make new version use a new hole set of js.
 if($('.reveal-modal.open').length == 0) {
   var $editProject     = $('#edit_project'),
       $projectData     = $('.show-project-data'),
       $editProjectForm = $('.edit-project-form');

   $editProject.click(function() {
     $projectData.hide();
     $editProjectForm.show();
   });

   new Projects();
 }
});
