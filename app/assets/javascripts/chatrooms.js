$(document).on('turbolinks:load', function() {
    $('.message-list-wrapper').scrollTop($('.message-list').prop('scrollHeight'));
    $('#new_message').focus();

    var isLoading = false;

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

    $('#message-list').scroll(function() {
        if ($('#message-list').scrollTop() < 1) {

            isLoading = true;
            var disable_loadmore = $('#message-list').data('disable-loadmore');
            if (disable_loadmore == true) return

            $('#loading').removeClass('hidden');
            var last_id = $('#message-list li').first().data('mes-id');

            $.ajax({
                url: window.location.href,
                type: 'GET',
                data: { last_id: last_id },
                dataType: 'script',
                success: function (response) {
                    var scroll_eml = $("[data-mes-id='" + last_id + "']");
                    isLoading = false;
                    $('#message-list').scrollTop(scroll_eml.offset().top);
                    $('#loading').addClass('hidden');
                }
            });
        }
    });

    $(document).on("click", ".delete-message", function(e) {
        e.preventDefault();
        var messageID = this.dataset.messageId;
        var urlMessage = window.location.href + "/messages/" + messageID

        $(".modal-delete-message").show();
        $("#btn-delede-message").attr("href", urlMessage)
    });

  $("#image_field_1").on("change", function () {
    var fileName = $(this).val();
    $("#btn-send-messages").prop('disabled', true);
    if(fileName) {
      $("#btn-send-messages").prop('disabled', false);
    }
  })

  $("#message_body").on('paste, keydown', function() {
    setTimeout(function(e) {
      var body = $("#message_body").val();
      $("#btn-send-messages").prop('disabled', true);
      if (body) {
        $("#btn-send-messages").prop('disabled', false);
      }
    }, 0);
  })

  $(document).on("click", "#open-modal-exchange-item", function(e) {
    e.preventDefault();
    $(".modal-exchange-item").show();
  });

  $(document).on("click", ".close-modal", function(e) {
    e.preventDefault();
    $(".modal-exchange-item").hide();
  });

  $(document).off('click', '.btn-exchange-complete');
  $(document).on("click", ".btn-exchange-complete", function(e) {
    e.preventDefault();
    var productId = document.querySelector('.btn-exchange-reject').dataset.product;
    var exchangeItemId = document.querySelector('.btn-exchange-reject').dataset.exchange;
    var chatRoomId = $('#chatroom_id').val();

    $.ajax({
      url: '/products/' + productId + '/update_exchange_item',
      type: 'PUT',
      data: {
        authenticity_token: $('meta[name="csrf-token"]').attr('content'),
        exchange_item_id: exchangeItemId,
        approve_exchange: true,
        chat_room_id: chatRoomId
      },
      dataType: 'script',
      success: function (response) {
        setTimeout(function(e) {
          $(".msgAlert").css("display", "none")
        }, 3000);
      }
    });
  });

  $(document).off('click', '.btn-exchange-reject');
  $(document).on("click", ".btn-exchange-reject", function(e) {
    e.preventDefault();

    var productId = document.querySelector('.btn-exchange-reject').dataset.product;
    var exchangeItemId = document.querySelector('.btn-exchange-reject').dataset.exchange;
    var chatRoomId = $('#chatroom_id').val();

    $.ajax({
      url: '/products/' + productId + '/update_exchange_item',
      type: 'PUT',
      data: {
        authenticity_token: $('meta[name="csrf-token"]').attr('content'),
        exchange_item_id: exchangeItemId,
        reject_exchange: true,
        chat_room_id: chatRoomId
      },
      dataType: 'script',
      success: function (response) {
        setTimeout(function(e) {
          $(".msgAlert").css("display", "none")
        }, 3000);
      }
    });
  });

  $(document).off('click', '#page-title-chatroom');
  $(document).on("click", "#page-title-chatroom", function(e) {
    if(e.target.className != "btn-exchange" && e.target.className != "btn-back") {
      $(".modal-exchange-item").hide();
    }
  });


  $(document).off('click', '.btn-submit-msg-topic');
  $(document).on("click", ".btn-submit-msg-topic", function(e) {
    e.preventDefault();

    var content = $(".message_body").val();
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
});
