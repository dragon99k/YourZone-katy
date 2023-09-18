// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery.min
//= require slick.min
//= require core
//= require_tree .

$(document).ready(function(){
  window.onclick = function (e) {
    modal = $('#modal-confirm-email')[0];
    button = $('#modal-confirm-email button')[0];
    if(e.target == modal || e.target == button) {
      $('#modal-confirm-email').hide();
    }
  }

  $(document).off('click', '#email-login');
  $(document).on("click", "#email-login", function(e) {
    $("#user_email").val('');
  });

  $(document).off('click', '#password-login');
  $(document).on("click", "#password-login", function(e) {
    $("#user_password").val('');
  });

  $(document).off('click', '#login-btn');
  $(document).on("click", "#login-btn", function(e) {
    e.preventDefault();

    var form = $("#new_user");
    var email = $("#user_email").val();

    $.ajax({
      url: '/cancel_memberships/check_user_for_login',
      type: 'POST',
      data: {
        authenticity_token: $('meta[name="csrf-token"]').attr('content'),
        email: email,
      },
      dataType: 'json',
      success: function (res) {
        if(res.data){
          $(".modal-check-login-user").show();
          $('#active-user-login').attr('data-email', email);
        }else{
          form.submit();
        }
      }
    });
  });

  $(document).off('click', '.close-modal');
  $(document).on("click", ".close-modal", function(e) {
    e.preventDefault();
    $('.modal-custom').hide();
  });

  $(document).off('click', '#active-user-login');
  $(document).on("click", "#active-user-login", function(e) {
    e.preventDefault();

    var form = $("#new_user");
    var email = $(this).attr('data-email');

    $.ajax({
      url: '/cancel_memberships/update_user_active',
      type: 'PUT',
      data: {
        authenticity_token: $('meta[name="csrf-token"]').attr('content'),
        email: email,
      },
      dataType: 'json',
      success: function (res) {
        if(res.data == true){
          form.submit();
          $(".modal-check-login-user").hide();
        }
      }
    });
  });
});