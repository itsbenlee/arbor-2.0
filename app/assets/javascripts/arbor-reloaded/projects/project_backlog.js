var commonGrowInputOptions = { minWidth: 100, maxWidth: 600, comfortZone: 20 };
$(document).ready(function(){
  if ($('.new-backlog-story').length > 0) {
    $('#role-input').autoGrowInput(commonGrowInputOptions);
    $('#action-input').autoGrowInput(commonGrowInputOptions);
    $('#result-input').autoGrowInput(commonGrowInputOptions);
  }
});
