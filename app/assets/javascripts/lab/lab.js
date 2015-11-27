if ($('#hypotheses').length) {
  $('input[type=text]').on('keydown keyup input propertychange change', function(e) {
    //mock html5 validation if safari, Ale
    if (is_safari && e.keyCode === 13 ) {
      preSubmitForm(this);
    }
  });
}
