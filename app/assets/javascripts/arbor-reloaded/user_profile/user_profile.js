$(document).on('click', '#copy-token', {}, function(event) {
  clipboard.copy($('#arbor-token-field').text());
  return false;
});



function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $('#img_prev').css('background-image', 'url(' + e.target.result + ')');
    };

    reader.readAsDataURL(input.files[0]);
  }
}
