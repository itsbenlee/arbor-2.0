function CustomTextArea() {
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
      $(this.form).submit();
      resizeTextarea(this);
      return false;
    }
  });

  window.onresize = function() {
    $('.ui-sortable-handle .backlog-placeholder.resizable-text-area').each(function(index, currentValue) {
      var offset = currentValue.offsetHeight - currentValue.clientHeight;
      $(currentValue).css('height', '10px').css('height', this.scrollHeight + offset);
    });
  };
}
