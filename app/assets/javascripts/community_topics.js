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

  var arr_word_found = new Array();
  $.ajax({
    url: "/list_word_founds",
    type: 'GET',
    data: {},
    dataType: 'json',
    success: function (response) {
      if(response.data.length > 0){
        arr_word_found = response.data
      }
    }
  });

  // $(".image_field").change(function() {
  //   var index = $(this).data('index');
  //   var peview = $('#preview_img_' + index);
  //   readURL(this, peview);
  //   $('#destroy_image_' + index).val(false);
  //   $('#remove_' + index).removeClass('hidden');
  // });

  $(".remove").on('click', function() {
    var index = $(this).data('index');
    $('#destroy_image_' + index).val(true);
    $('#image_field_' + index).val('');
    $('#remove_' + index).addClass('hidden');
    $('#preview_img_' + index).attr('src', '/images/original/camera.png');
  });

  $('#form-messages-community').scrollTop($('.community-message-list').prop('scrollHeight'));
  $('#new-community-message').focus();

  $("#community_topic_title, #community_topic_description").on('paste, keydown', function() {
    setTimeout(function(e) {
      var title = $("#community_topic_title").val();
      var content = $("#community_topic_description").val();
      $("#create-new-community-topic").addClass("btn-disabled");
      $("#create-new-community-topic").prop('disabled', true);

      if (title && content) {
        $("#create-new-community-topic").removeClass("btn-disabled");
        $("#create-new-community-topic").prop('disabled', false);
      }
    }, 0);
  })

  $("#delete-topic").on('click', function(e) {
    e.preventDefault();
    $(".modal-delete-topic").show();
  });

  $(document).off('click', '#create-new-community-topic');
  $(document).on("click", "#create-new-community-topic", function(e) {
    e.preventDefault();

    var title = $("#community_topic_title").val();
    var content = $("#community_topic_description").val();
    var found = false;
    var form = $(this).closest("form");
    for (var i = 0; i < arr_word_found.length && !found; i++) {
      if (title.includes(arr_word_found[i].word) === true || content.includes(arr_word_found[i].word) === true) {
        found = true;
        $(".modal-check-word-violate-group").show();
        break;
      }
    }

    if(found === false) {
      form.submit();
    }
  });
});
