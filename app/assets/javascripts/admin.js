//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery.min
//= require bootstrap-sprockets
//= require adminlte
//= require slick.min
//= require admin/arm_chart
//= require admin/users

$(document).on('turbolinks:load', function() {
  function readURL(input, preview) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function(e) {
        preview.attr('src', e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
    }
  }

  $('.preview-image').on('click', function () {
    var index = $(this).data('index');
    $('#image_field_' + index).click();
  })

  $(".image_field").change(function() {
    var index = $(this).data('index');
    var peview = $('#preview_' + index);
    readURL(this, peview);
    $('#destroy_image_' + index).val(false);
    $('#remove_' + index).removeClass('hidden');
  });

  $(".remove").on('click', function() {
    var index = $(this).data('index');
    $('#destroy_image_' + index).val(true);
    $('#image_field_' + index).val('');
    $('#remove_' + index).addClass('hidden');
    $('#preview_' + index).attr('src', '/images/original/missing.png');
  });

  $('.gallery').slick({
    arrows: false,
    dots: true,
    centerMode: true,
    centerPadding: '10%',
    slidesToShow: 1,
    appendDots: ".slider-nav",
    responsive: [
      {
        breakpoint: 640,
        settings: {
          centerMode: false,
        }
      }
    ]
  });

  $(".image_field").on("change", function () {
    var fileName = $(this).val();
    var title = $("#community_name").val();
    var content = $("#community_description").val();
    $("#create-new-group").addClass("btn-disabled");
    $("#create-new-group").prop('disabled', true);
    if(fileName && title && content) {
      $("#create-new-group").removeClass("btn-disabled");
      $("#create-new-group").prop('disabled', false);
    }
  })

  $("#community_name, #community_description").on('paste, keydown', function() {
    setTimeout(function(e) {
      var imgField = $(".image-field");
      var title = $("#community_name").val();
      var content = $("#community_description").val();
      var fileName = false;
      $("#create-new-group").addClass("btn-disabled");
      $("#create-new-group").prop('disabled', true);
      jQuery.each(imgField, function (i, val) {
        if (val.getElementsByClassName("image_field")[0].value) {
          return fileName = true;
        }
      });
      if (fileName && title && content) {
        $("#create-new-group").removeClass("btn-disabled");
        $("#create-new-group").prop('disabled', false);
      }
    }, 0);
  })
})
