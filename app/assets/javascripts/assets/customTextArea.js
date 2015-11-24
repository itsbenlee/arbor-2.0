function CustomTextArea() {
  var errorsToControl = ["Description can't be blank"]
  var resizeTextarea = function(el) {
    var offset = el.offsetHeight - el.clientHeight;
    $(el).css('height', '10px').css('height', el.scrollHeight + offset);
  };

  $('.resizable-text-area').each(function() {
    $(this).height( 0 );
    $(this).height( this.scrollHeight );

    $(this).on('keyup input', function() { resizeTextarea(this); });
  });

  $('.resizable-text-area').off('keypress').on('keypress', function(e) {
    if(e.keyCode === 13 ) {
      if($(this).text() == "") {
        if($('.alert-box.error').text().indexOf("can't be blank") == -1) {
          $(this.form).submit();
          resizeTextarea(this);
        }
      }
      return false;
    }
  });

  $('.resizable-text-area').focus(function(){
    $('#save-canvas').show();
  });

  $('.resizable-text-area').blur(function(){
    $('#save-canvas').hide();
  });

  window.onresize = function() {
    $('.ui-sortable-handle .backlog-placeholder.resizable-text-area').each(function(index, currentValue) {
      el = this
      var offset = currentValue.offsetHeight - currentValue.clientHeight;
      $(this).css('height', '10px').css('height', this.scrollHeight + offset);
    });
  }
}
