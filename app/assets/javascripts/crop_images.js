$(document).on('turbolinks:load', function() {
  var cropper;
  var cropperModalId = '#cropImagePop';
  var $jsPhotoUploadInput = $('.image_field');

  $jsPhotoUploadInput.on('change', function(e) {
    e.preventDefault();
    var files = this.files;
    var index = $(this).data('index');
    $('#cropImageBtn').attr('data-id', parseInt(index));
    if (files.length > 0) {
      var photo = files[0];

      var reader = new FileReader();
      reader.onload = function(event) {
        var image = $('.js-avatar-preview')[0];
        image.src = event.target.result;

        if ($(window).width() <= 320) {
          var minWidth = 250;
        } else {
          var minWidth = 300;
        }

        cropper = new Cropper(image, {
          viewMode: 0,
          aspectRatio: 1,
          minContainerWidth: minWidth,
          minContainerHeight: 300,
          minCropBoxWidth: 300,
          minCropBoxHeight: 300,
          minCanvasWidth: 300,
          minCanvasHeight: 300,
          cropBoxResizable: false,
          crop: function (e) {
            cropper.options.viewMode = 1;
          }
        });

        $(cropperModalId).modal();
      };
      reader.readAsDataURL(photo);
    }
  });

  $('.crop-custom').on('click', function (e) {
    e.preventDefault();
    cropper.reset();
  });

  $('#cropImageBtn').off('click', function(e) {});
  $('#cropImageBtn').on('click', function(event) {
    event.preventDefault();
    var index = $('#cropImageBtn').attr('data-id');
    $('#cropImagePop').modal('hide');

    var canvas = cropper.getCroppedCanvas({fillColor: '#fff'});
    var base64encodedImage = canvas.toDataURL();
    $('#preview_' + index).attr('src', base64encodedImage);
    $('#remove_' + index).removeClass('hidden');
    $('#image_field_hidden_' + index).attr('value', base64encodedImage);
    $('#destroy_image_' + index).val(false);
    cropper.destroy();
  });

  $('#cancle-crop').on('click', function(event) {
    event.preventDefault();
    $(cropperModalId).modal('hide');
    cropper.destroy();
  });
});