$(document).on('turbolinks:load', function() {
  if(window.location.href != window.location.protocol + "//" + window.location.host + "/users/sign_in") {
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

    $(".remove").on('click', function() {
        var index = $(this).data('index');
        $('#destroy_image_' + index).val(true);
        $('#image_field_' + index).val('');
        $('#remove_' + index).addClass('hidden');
        $('#preview_' + index).attr('src', '/images/original/missing.png');
        if($('.remove.hidden').length === $('.remove').length ) {
            $("#create-new-group").addClass("btn-disabled");
            $("#create-new-group").prop('disabled', true);
            $("#create-new-product").addClass("btn-disabled");
            $("#create-new-product").prop('disabled', true);
            $("#create-new-community-topic").addClass("btn-disabled");
            $("#create-new-community-topic").prop('disabled', true);
        }
    });

    if ($('#visits').length > 0) {
        var nearToBottom = 200;
        var isLoading = false;

        $(window).scroll(function () {
            if ($(window).scrollTop() + $(window).height() > $(document).height() - nearToBottom) {
                if ($('#visits').length > 0) {
                    var visits = $('#visits')
                    var page = visits.data('page');
                    var total = visits.data('total');

                    if (page >= total || isLoading) {
                      return;
                    }

                    page += 1
                    isLoading = true;
                    $('#loading').removeClass('hidden');

                    $.ajax({
                        url: window.location.href,
                        type: 'GET',
                        data: {page: page},
                        dataType: 'script',
                        success: function (response) {
                            $('#loading').addClass('hidden');
                            visits.data('page', page);
                        }
                    });
                }
            }
        })
    }

    $('.rating-user').on('click', '*[class*=rating-]', function(e) {
      e.preventDefault();
      var rate;
      var content = $("#content").val();
      if($(this).hasClass("rating-1")) {
        if ($(this).hasClass("checked")) {
          $(".rating-1").removeClass('checked');
          $(".rating-2").removeClass('checked');
          $(".rating-3").removeClass('checked');
          $(".rating-4").removeClass('checked');
          $(".rating-5").removeClass('checked');
          rate = 0;
        } else {
          $(".rating-1").addClass('checked');
          rate = 1;
        }
      }else if($(this).hasClass("rating-2")) {
        if ($(this).hasClass("checked")) {
          $(".rating-2").removeClass('checked');
          $(".rating-3").removeClass('checked');
          $(".rating-4").removeClass('checked');
          $(".rating-5").removeClass('checked');
          rate = 1;
        } else {
          $(".rating-1").addClass('checked');
          $(".rating-2").addClass('checked');
          rate = 2;
        }
      }else if($(this).hasClass("rating-3")) {
        if ($(this).hasClass("checked")) {
          $(".rating-3").removeClass('checked');
          $(".rating-4").removeClass('checked');
          $(".rating-5").removeClass('checked');
          rate = 2;
        } else {
          $(".rating-1").addClass('checked');
          $(".rating-2").addClass('checked');
          $(".rating-3").addClass('checked');
          rate = 3;
        }
      }else if($(this).hasClass("rating-4")) {
        if ($(this).hasClass("checked")) {
          $(".rating-4").removeClass('checked');
          $(".rating-5").removeClass('checked');
          rate = 3;
        } else {
          $(".rating-1").addClass('checked');
          $(".rating-2").addClass('checked');
          $(".rating-3").addClass('checked');
          $(".rating-4").addClass('checked');
          rate = 4;
        }
      }else if($(this).hasClass("rating-5")) {
        if ($(this).hasClass("checked")) {
          $(".rating-5").removeClass('checked');
          rate = 4;
        } else {
          $(".rating-1").addClass('checked');
          $(".rating-2").addClass('checked');
          $(".rating-3").addClass('checked');
          $(".rating-4").addClass('checked');
          $(".rating-5").addClass('checked');
          rate = 5;
        }
      }
      $('#form-rate-user').find("#get-rate").val(rate);
      $('#form-update-rate-user').find("#get-rate-update").val(rate);

      if(content.length > 1) {
        $(".btn-submit-rating").prop('disabled', false);
      }
    });

    $("#content").on('paste, keydown', function() {
      setTimeout(function (e) {
        var rate = $("#get-rate").val();
        var content = $("#content").val();
        if(rate && content.length > 1) {
          $(".btn-submit-rating").prop('disabled', false);
        } else {
          $(".btn-submit-rating").prop('disabled', true);
        }
      }, 0);
    });

    $("#block-user").on('click', function(e) {
        e.preventDefault();
        $(".modal-alert-block").show();
        var el = document.getElementById("myLinks");
        if (el.style.display === "block") {
            el.style.display = "none";
        } else {
            el.style.display = "block";
        }
    });

    $(".rate-user-update").on('click', function(e) {
        e.preventDefault();
        $(".modal-update-rate-user").show();
    });

    $("#facebook_id").on('paste, keydown', function() {
        setTimeout(function(e) {
            var facebook_id = $("#facebook_id").val();
            var facebook_url = "https://www.facebook.com/" + facebook_id
            if(facebook_id.length>0){
                $('.facebook-url-note').html(facebook_url);
            }else{
                $('.facebook-url-note').html("https://www.facebook.com/ユーザID");
            }
        }, 0);
    });

    $("#instagram_id").on('paste, keydown', function() {
        setTimeout(function(e) {
            var instagram_id = $("#instagram_id").val();
            var instagram_url = "https://www.instagram.com/" + instagram_id

            if(instagram_id.length>0){
                $('.instagram-url-note').html(instagram_url);
            }else{
                $('.instagram-url-note').html("https://www.instagram.com/ユーザID");
            }
        }, 0);
    });

    $("#youtube_id").on('paste, keydown', function() {
        setTimeout(function(e) {
            var youtube_id = $("#youtube_id").val();
            var youtube_url = "https://www.youtube.com/channel/" + youtube_id

            if(youtube_id.length>0){
                $('.youtube-url-note').html(youtube_url);
            }else{
                $('.youtube-url-note').html("https://www.youtube.com/channel/チャンネルID");
            }
        }, 0);
    });

    $("#btn-edit-profie").on('click', function() {
        window.location.href = '/profile/edit';
    });


    $(".cancle-membership").on('click', function() {
      $(".modal-confirm-cancel-membership").show()
    });

    $(document).off('click', '#btn-submit-rating');
    $(document).on("click", "#btn-submit-rating", function(e) {
      e.preventDefault();

      var content = $("#content").val();
      var found = false;

      var form = $(this).closest("form");
      for (var i = 0; i < arr_word_found.length && !found; i++) {
        if (content.includes(arr_word_found[i].word) === true) {
          found = true;
          $(".modal-check-word-violate-group").show();
          break;
        }
      }

      if(found === false) {
        form.submit();
      }
    });

  $(document).off('click', '.avatar-user');
  $(document).on("click", ".avatar-user", function(e) {
    e.preventDefault();
    $(".modal-show-avatar-user").show();
  });

  $(document).off('click', '#show-avatar-user');
  $(document).on("click", "#show-avatar-user", function(e) {
    if(e.target.id === "show-avatar-user") {
      $(".modal-show-avatar-user").hide();
    }
  });

  $('#open-menu-user').on('click', function(e) {
    var el = document.getElementById("myLinks");
    if (el.style.display === "block") {
      el.style.display = "none";
    } else {
      el.style.display = "block";
    }
  });
})
