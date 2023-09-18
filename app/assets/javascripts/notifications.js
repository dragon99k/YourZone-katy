$(document).on('turbolinks:load', function() {

  $(document).off('click', '#switch-message');
  $(document).on("click", "#switch-message", function(e) {
    if($('#switch-message').prop('checked')) {
      $('#notification_message_type').val("0")
    } else {
      $('#notification_message_type').val("1")
    }
  });

  $(document).off('click', '#switch-like');
  $(document).on("click", "#switch-like", function(e) {
    if($('#switch-like').prop('checked')) {
      $('#notification_like_type').val("0")
    } else {
      $('#notification_like_type').val("1")
    }
  });

  $(document).off('click', '#switch-notification');
  $(document).on("click", "#switch-notification", function(e) {
    if($('#switch-notification').prop('checked')) {
      $('#notification_notification_type').val("0")
    } else {
      $('#notification_notification_type').val("1")
    }
  });
});
