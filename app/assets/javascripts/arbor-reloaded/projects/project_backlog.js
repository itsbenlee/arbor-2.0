var commonGrowInputOptions = { minWidth: 180, maxWidth: 600, comfortZone: 30 };
$(document).ready(function(){
  if ($('.new-backlog-story').length > 0) {
    $('#role-input').autoGrowInput(commonGrowInputOptions);
    $('#action-input').autoGrowInput(commonGrowInputOptions);
    $('#result-input').autoGrowInput(commonGrowInputOptions);
    autogrowInputs();
  }
});

// Attach autogrow on form submit, Ale
$('#new_user_story').submit(function() {
  autogrowInputs();
});

function autogrowInputs(){
  $('#role-input').trigger('autogrow');
  $('#action-input').trigger('autogrow');
  $('#result-input').trigger('autogrow');
}
