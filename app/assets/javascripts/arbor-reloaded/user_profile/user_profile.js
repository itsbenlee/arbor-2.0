$(document).on('click', '#copy-token', {}, function(event) {
  clipboard.copy($('#arbor-token-field').text());
  return false;
});

var MAX_FILE_SIZE = 3;

function fileIsAnImage(file) {
  var imageType = file.type && file.type.split("/")[0];

  return imageType === "image" && file.size > 0;
}

function fileSizeIsValid(file, maxSize) {
  return ((file.size / 1024) / 1024) <= maxSize;
}

function validateFile(input) {
  var file = input.files && input.files[0],
      error = null;

  if (!file) {
    return { error: null, file: null };
  }

  if (fileSizeIsValid(file, MAX_FILE_SIZE)) {
    if (fileIsAnImage(file)) {
      return { file: file };
    }

    error = 'File is not an image';
  } else {
    error = 'File is too big';
  }

  input.value = null;

  return { file: null, error: error };
}

function displayFormError(message) {
  $(document).trigger('formNotification.error', message);
}

function readURL(input) {
  var result = validateFile(input),
      reader = null;


  if (!result.file) {
    if (result.error) {
      displayFormError(result.error);
    }

    $('#img_prev').css('background-image', '');
    return false;
  }

  reader = new FileReader();

  reader.onerror = function (e) {
    console.log("Error", e);
    input.value = null;
    displayFormError('Something went wrong with that file');
  };

  reader.onload = function (e) {
    $('#img_prev').css('background-image', 'url(' + e.target.result + ')');
  };

  reader.readAsDataURL(result.file);
}
