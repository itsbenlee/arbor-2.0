function CustomTextArea() {
  var resizeTextarea = function(el) {
    var offset = el.offsetHeight - el.clientHeight;
    $(el).css('height', 'auto').css('height', el.scrollHeight + offset);
  };

  $('.resizable-text-area').each(function() {
    $(this).height( 0 );
    $(this).height( this.scrollHeight );

    $(this).on('keyup input', function() { resizeTextarea(this); });
  });

  $('.resizable-text-area').bind('keypress', function(e) {
    if(e.keyCode === 13 ) {
      $(this.form).submit();
      resizeTextarea(this);
      return false;
    }
  })
}
