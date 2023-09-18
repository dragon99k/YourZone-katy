$(document).on('turbolinks:load', function() {

  $("#delete-user").on("click", function () {
    var arrCheckbox = $("input[type='checkbox']");
    var arrDataId = new Array();
    arrCheckbox.each(function( index ) {
      if(this.checked === true){
        arrDataId.push(this.dataset.id);
      }
    });
    arrDataId = (arrDataId.filter(Boolean));
    if(arrDataId.length > 0) {
      $.ajax({
        url: "/admin/users/destroy_multi_users",
        type: 'PUT',
        data: {
          authenticity_token: $('meta[name="csrf-token"]').attr('content'),
          arr_user_id: arrDataId
        },
        dataType: 'script',
        success: function (res) {
          window.location.reload()
        }
      });
    }
  })
});
