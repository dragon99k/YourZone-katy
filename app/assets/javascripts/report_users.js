$(document).on('turbolinks:load', function() {
  var arr_word_found = new Array();
  $.ajax({
    url: "/list_word_founds",
    type: 'GET',
    data: {},
    dataType: 'json',
    success: function (response) {
      if (response.data.length > 0) {
        arr_word_found = response.data
      }
    }
  });

  $("#title-report, #content-report").on('paste, keydown', function () {
    setTimeout(function (e) {
      var title = $("#title-report").val();
      var content = $("#content-report").val();
      if (title && content) {
        $("#btn-submit-report").prop('disabled', false);
        $("#btn-submit-report").removeClass("btn-disabled");
      } else {
        $("#btn-submit-report").prop('disabled', true);
        $("#btn-submit-report").addClass("btn-disabled");
      }
    }, 0);
  });

  $(document).off('click', '#btn-submit-report');
  $(document).on("click", "#btn-submit-report", function (e) {
    e.preventDefault();

    var content = $("#content-report").val();
    var found = false;
    var form = $(this).closest("form");
    for (var i = 0; i < arr_word_found.length && !found; i++) {
      if (content.includes(arr_word_found[i].word) === true) {
        found = true;
        $(".modal-check-word-violate-group").show();
        break;
      }
    }

    if (found === false) {
      form.submit();
    }
  });
});