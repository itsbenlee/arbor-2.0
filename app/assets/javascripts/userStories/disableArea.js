$('#select_stories_lnk').click(function()  {
  var form = document.getElementById('new_user_story');
      filterVal = 'blur(3px)';
  $(form).addClass('disabled-items');

  $('.user-story-edit-form')
   .css('filter',filterVal)
   .css('webkitFilter',filterVal)
   .css('mozFilter',filterVal)
   .css('oFilter',filterVal)
   .css('msFilter',filterVal);

  $(form.elements).each(function(index, currentValue) {
    //iterate over elements on the form, Rosina
    $(currentValue).attr('readonly', true);
  });

  var idElementsToDisable = ['#user_story_estimated_points', '#user_story_priority'];
  for (var i = 0; i < idElementsToDisable.length; i++){
    $(idElementsToDisable[i]).hide();
    $(idElementsToDisable[i]).css('cursor', 'pointer');
  }
});
