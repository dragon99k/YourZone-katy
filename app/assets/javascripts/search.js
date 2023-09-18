$(document).on('turbolinks:load', function() {

    if ($('#search').length > 0) {
        var nearToBottom = 200;
        var isLoading = false;

        $(window).scroll(function () {
            if ($(window).scrollTop() + $(window).height() > $(document).height() - nearToBottom) {
              if ($('#search').length > 0) {
                var usersEml = $('#search_users')
                var page = usersEml.data('page');
                var total = usersEml.data('total');

                if (page >= total || isLoading) {
                  return;
                }

                page += 1
                isLoading = true;
                $('#loading').removeClass('hidden');
                $.ajax({
                  url: "/search",
                  type: 'GET',
                  data: {page: page},
                  dataType: 'script',
                  success: function (response) {
                    $('#loading').addClass('hidden');
                    usersEml.data('page', page);
                  }
                });
              }
            }
        })
    }
});
