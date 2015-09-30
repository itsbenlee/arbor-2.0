$(document).ready(function() {
  var $hypothesisShow     = $('.hypothesis-show'),
      $hypothesisShowType = $('.hypothesis-type-show');

  function displayEditForm(hypothesisId) {
    var $editHypothesisById = $('.hypothesis-edit[data-id=' +
      hypothesisId + ']'),
        $editHypothesisByIdType = $('.hypothesis-type-edit[data-id=' +
          hypothesisId + ']'),
        $hypothesisShowById =$('.hypothesis-show[data-id=' +
          hypothesisId + ']'),
        $hypothesisShowTypeById = $('.hypothesis-type-show[data-id=' +
          hypothesisId + ']'),
        $editHypothesis = $('.hypothesis-edit'),
        $editHypothesisType  = $('.hypothesis-type-edit');

    $hypothesisShow.show();
    $hypothesisShowType.show();
    $hypothesisShowById.hide();
    $hypothesisShowTypeById.hide();
    $editHypothesis.hide();
    $editHypothesisType.hide();
    $editHypothesisById.show();
    $editHypothesisByIdType.show();
  }

  $hypothesisShow.click(function() {
    var hypothesisId = $(this).data('id');
    displayEditForm(hypothesisId);
  });

  $hypothesisShowType.click(function() {
    var hypothesisId = $(this).data('id');
    displayEditForm(hypothesisId);
  });

  new UserStory();
  new Goal();
});
