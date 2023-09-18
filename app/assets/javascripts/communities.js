$(document).on('turbolinks:load', function() {

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

    if ($('#search_communities').length > 0) {
        var nearToBottom = 200;
        var isLoading = false;

        $(window).scroll(function () {
            if ($(window).scrollTop() + $(window).height() > $(document).height() - nearToBottom) {
                if ($('#search_communities').length > 0) {
                    var searchEml = $('#search_communities')
                    var page = searchEml.data('page');
                    var total = searchEml.data('total');

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
                            searchEml.data('page', page);
                        }
                    });
                }
            }
        })
    }

    $(".community-images .image_field").on("change", function () {
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
                if (val.getElementsByClassName("destroy_image")[0].value) {
                  return fileName = true;
                }
            });
            if (fileName && title && content) {
                $("#create-new-group").removeClass("btn-disabled");
                $("#create-new-group").prop('disabled', false);
            }
        }, 0);
    })

    $("#delete-group").on('click', function(e) {
        e.preventDefault();
        $(".modal-delete-group").show();
    });

    $("#btn-join-group, #join-community").on('click', function(e) {
        e.preventDefault();
        var el = document.getElementById("myLinks");
        el.style.display = "none";

        var communityId = $("#communityId").val();

        $.ajax({
            url: '/communities/' + communityId + '/favorite',
            type: 'POST',
            data: {
              authenticity_token: $('meta[name="csrf-token"]').attr('content'),
            },
            dataType: 'script',
            success: function (response) {
              $(".modal-join-group").show();
            }
        });
    });

    $("#out-community").on('click', function(e) {
        e.preventDefault();
        var el = document.getElementById("myLinks");
        el.style.display = "none";
        $(".modal-out-group").show();
    });

    $("#out-group").on('click', function(e) {
        e.preventDefault();
        var communityId = $("#community-id").val();

        $.ajax({
            url: '/communities/' + communityId + '/favorite',
            type: 'POST',
            data: {
                authenticity_token: $('meta[name="csrf-token"]').attr('content'),
            },
            dataType: 'script',
            success: function (response) {
              $(".modal-out-group").hide();
              window.location.href = '/communities/' + communityId;
            }
        });
    });


    $("#join-group").on('click', function(e) {
        e.preventDefault();
        var communityId = $("#community-id").val();
        $(".modal-join-group").hide();
        window.location.href = '/communities/' + communityId;
    });


    $('#open-menu-community, #open-menu-product').on('click', function(e) {
      var el = document.getElementById("myLinks");
      if (el.style.display === "block") {
        el.style.display = "none";
      } else {
        el.style.display = "block";
      }
    });

  $(document).on("click", ".disband-user-btn, .btn-reject-community", function(e) {
    e.preventDefault();
    userId = $(this).data('user-id')
    communityId = $(this).data('community-id')
    $(".modal-disband-user-group").show();

    if(e.target.id == "is-user") {
      $('#reject-user-group').attr('data-communityid', communityId)
      $('#reject-user-group').attr('data-userid', userId)
    } else {
      $('#disband_user_group').attr('data-userid', userId)
    }
  });

  $(document).on("click", ".close-modal", function(e) {
    e.preventDefault();
    $(".modal-disband-user-group").hide();
  });

  $(document).off('click', '#disband_user_group, #reject-user-group');
  $(document).on("click", "#disband_user_group, #reject-user-group", function(e) {
    e.preventDefault();

    if(e.target.id == "reject-user-group") {
      var userId = document.querySelector('#reject-user-group').dataset.userid;
      var communityId = document.querySelector('#reject-user-group').dataset.communityid;
    } else {
      var userId = document.querySelector('#disband_user_group').dataset.userid;
      var communityId = $('#community_id').val();
    }

    $.ajax({
      url: '/communities/' + communityId + '/un_favorite',
      type: 'PUT',
      data: {
        authenticity_token: $('meta[name="csrf-token"]').attr('content'),
        user_id: userId
      },
      dataType: 'script',
      success: function (response) {
        window.location.reload();
      }
    });
  });

  $(document).off('click', '#see-more-text');
  $(document).on("click", "#see-more-text", function(e) {
    var description = $("#communities").find(".description");
    if(description.hasClass("long-text")) {
      description.removeClass("long-text");
      $("#see-more-text").find(".fas").addClass("fa-angle-grown");
      $("#see-more-text").find(".fas").removeClass("fa-angle-up")
    }else{
      description.addClass("long-text");
      $("#see-more-text").find(".fas").removeClass("fa-angle-grown");
      $("#see-more-text").find(".fas").addClass("fa-angle-up");
    }
  });

  $(document).off('click', '#create-new-group');
  $(document).on("click", "#create-new-group", function(e) {
    e.preventDefault();

    var title = $("#community_name").val();
    var content = $("#community_description").val();
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

  $('a[id^=favorite_].not_joined').click(function(e) {
    e.preventDefault()
    if (!$(this).hasClass('not_joined')) return
    $('#modal-join-community').show();
    $('#modal-join-community').find('.modal-title').text($(this).data('community-name'))
  })

  if ($('#seen-notification-btn').length > 0)
    $('#seen-notification-btn').click();
});
