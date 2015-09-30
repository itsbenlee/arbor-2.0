$(document).ready(function() {
  var $hypothesisShow     = $('.hypothesis-show'),
      $hypothesisShowType = $('.hypothesis-type-show');


  function displayEditForm(hypothesisId) {
    var $editHypothesisById = $('.hypothesis-edit[data-id=' +
      hypothesisId + ']'),
        $hypothesisShowById =$('.hypothesis-show[data-id=' +
          hypothesisId + ']'),
        $editHypothesis = $('.hypothesis-edit');

    $hypothesisShow.show();
    $hypothesisShowById.hide();
    $editHypothesis.hide();
    $editHypothesisById.show();
  }

  function setType() {
    var selectedOption = $('.type option:selected');

    selectedOption.each(function() {
      var $this = $(this),
          $span = $this.parent().siblings('.dynamic-width');

      if (!$this.val() == '') {
        $this.parent().removeClass('empty');
        $span.html($this.text());
        $this.parent().width($span.width());
      } else {
        $this.parent().addClass('empty');
      }
    });
  }

  $hypothesisShow.click(function() {
    var hypothesisId = $(this).data('id');
    displayEditForm(hypothesisId);
  });

  $hypothesisShowType.click(function() {
    var hypothesisId = $(this).data('id');
    displayEditForm(hypothesisId);
  });

  new setType();
  new UserStory();
  new Goal();
});
