$(document).on('turbolinks:load', function() {
  $(document).on("click", ".block-user-btn", function(e) {
    e.preventDefault();
    userId = $(this).data('user-id')
    $(".modal-alert-block-list").show();
    $('#block_user').attr('data-userid', userId)
  });

  $(document).on("click", ".close-modal", function(e) {
    e.preventDefault();
    $(".modal-alert-block-list").hide();
  });

  $(document).off('click', '#block_user');
  $(document).on("click", "#block_user", function(e) {
    e.preventDefault();
    var userId = document.querySelector('#block_user').dataset.userid;

    $.ajax({
      url: '/users/' + userId + '/un_block',
      type: 'PUT',
      data: {
        authenticity_token: $('meta[name="csrf-token"]').attr('content'),
        user_id: userId,
        is_un_block: true,
      },
      dataType: 'script',
      success: function (response) {
        window.location.reload();
      }
    });
  });
});
