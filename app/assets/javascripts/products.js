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


  if ($('#search_products').length > 0) {
    var nearToBottom = 200;
    var isLoading = false;

    $(window).scroll(function () {
      if ($('#products').scrollTop() + $('#products').height() > $(document).height() - nearToBottom) {
        if ($('#search_products').length > 0) {
          var prodEml = $('#search_products')
          var page = prodEml.data('page');
          var total = prodEml.data('total');

          if (page >= total || isLoading) {
            return;
          }

          page += 1
          isLoading = true;
          $('#loading').removeClass('hidden');
          $.ajax({
            url: "/products",
            type: 'GET',
            data: {page: page},
            dataType: 'script',
            success: function (response) {
              $('#loading').addClass('hidden');
              prodEml.data('page', page);
            }
          });
        }
      }
    })
  }

  $(".image_field").on("change", function () {
    var fileName = $(this).val();
    var title = $("#product_title").val();
    var content = $("#product_description").val();
    var category = $('#product_category').val();

    $("#create-new-product").addClass("btn-disabled");
    $("#create-new-product").prop('disabled', true);
    if (category === "0") {
      if (fileName && title && content) {
        $("#create-new-product").removeClass("btn-disabled");
        $("#create-new-product").prop('disabled', false);
      }
    } else {
      if (title && content) {
        $("#create-new-product").removeClass("btn-disabled");
        $("#create-new-product").prop('disabled', false);
      }
    }
  })

  $("#product_title, #product_description").on('paste, keydown', function () {
    setTimeout(function (e) {
      var imgField = $(".image-field");
      var title = $("#product_title").val();
      var content = $("#product_description").val();
      var fileName = false;
      var category = $('#product_category').val();

      $("#create-new-product").addClass("btn-disabled");
      $("#create-new-product").prop('disabled', true);
      jQuery.each(imgField, function (i, val) {
        if (val.getElementsByClassName("destroy_image")[0].value) {
          return fileName = true;
        }
      });

      if (category === "0") {
        if (fileName && title && content) {
          $("#create-new-product").removeClass("btn-disabled");
          $("#create-new-product").prop('disabled', false);
        }
      } else {
        if (title && content) {
          $("#create-new-product").removeClass("btn-disabled");
          $("#create-new-product").prop('disabled', false);
        }
      }
    }, 0);
  })

  $("#product_category").on("change", function () {
    if ($(this).val() === "1") {
      $('.product-images').find(".image-required").css('display', 'none')
    } else {
      $('.product-images').find(".image-required").css('display', 'block')
    }
  });

  $(document).off('click', '#delete-product, #stop-product, #not-stop-product');
  $(document).on("click", "#delete-product, #stop-product, #not-stop-product", function (e) {
    e.preventDefault();
    var el = document.getElementById("myLinks");
    if (el.style.display === "block") {
      el.style.display = "none";
    } else {
      el.style.display = "block";
    }

    if (e.target.id == "delete-product") {
      $(".modal-delete-product").show();
    } else if (e.target.id == "stop-product" || e.target.id == "not-stop-product") {
      $(".modal-stop-product").show();
    }
  });

  $(document).off('click', '#create-new-product, .edit-product');
  $(document).on("click", "#create-new-product, .edit-product", function (e) {
    e.preventDefault();

    var title = $("#product_title").val();
    var content = $("#product_description").val();
    var found = false;
    var form = $(this).closest("form");
    for (var i = 0; i < arr_word_found.length && !found; i++) {
      if (title.includes(arr_word_found[i].word) === true || content.includes(arr_word_found[i].word) === true) {
        found = true;
        $(".modal-check-word-violate-group").show();
        break;
      }
    }

    if (found === false) {
      form.submit();
    }
  });

  $(document).off('click', '.close-modal-check-words');
  $(document).on("click", ".close-modal-check-words", function (e) {
    e.preventDefault();

    $(".modal-check-word-violate-group").hide();
  });

  function geoFindMe() {
    var status = document.querySelector('#status');
    var longitudeEl = document.querySelector('#product_longitude');
    var latitudeEl = document.querySelector('#product_latitude');

    function success(position) {
      var latitude = position.coords.latitude;
      var longitude = position.coords.longitude;
      var data = [{"id": "",
        "title": "",
        "longitude": longitude,
        "latitude": latitude
      }];

      status.textContent = '';
      longitudeEl.value = longitude;
      latitudeEl.value = latitude;

      document.querySelector('.show-map').style.display = "block";
      google.maps.event.addDomListener(window, 'load', initialize(data, 20));
    }

    function error() {
      status.textContent = '現在地を取得できませんでした。';
    }

    if (!navigator.geolocation) {
      status.textContent = '現在地を取得できませんでした。';
    } else {
      navigator.geolocation.getCurrentPosition(success, error);
    }
  }

  $(document).on("click", ".btn-get-location", geoFindMe)

  var map;

  function initialize(data, zoom) {
    // Giving the map som options
    var mapOptions = {
      zoom: zoom,
      center: new google.maps.LatLng(data[0].latitude, data[0].longitude)
    };
    // Creating the map
    map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    // Looping through all the entries from the JSON data
    for (var i = 0; i < data.length; i++) {
      // Current object
      var obj = data[i];
      if(obj.icon != undefined){
        var image = {
          url: obj.icon,
          scaledSize: new google.maps.Size(28, 28),
          origin: new google.maps.Point(0, 0),
          anchor: new google.maps.Point(0, 28),
        };
      } else {
        var image = {
          url: "http://www.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png",
          scaledSize: new google.maps.Size(28, 28),
          origin: new google.maps.Point(0, 0),
          anchor: new google.maps.Point(0, 28),
        };
      }
      // Adding a new marker for the object
      var marker = new google.maps.Marker({
        position: new google.maps.LatLng(obj.latitude, obj.longitude),
        map: map,
        icon: image
        // title: obj.title // this works, giving the marker a title with the correct title
      });
      // Adding a new info window for the object
      var clicker = addClicker(marker, obj.title);
    } // end loop
    // Adding a new click event listener for the object
    function addClicker(marker, content) {
      google.maps.event.addListener(marker, 'click', function () {
        if (infowindow) {
          infowindow.close();
        }
        infowindow = new google.maps.InfoWindow({content: content});
        infowindow.open(map, marker);
      });
    }
  }

  var url = window.location.href.split("/");
  var id = parseInt(url[url.length - 1]);

  if(window.location.href === window.location.protocol + "//" + window.location.host + "/products/" + id){
    $.ajax({
      url: "/products/" + id,
      type: 'GET',
      data: {},
      dataType: 'json',
      success: function (res) {
        if(res.product != [] && res.product[0] != undefined) {
          if(res.product[0].longitude != null || res.product[0].latitude != null) {
            document.querySelector('.show-map').style.display = "block";
            google.maps.event.addDomListener(window, 'load', initialize(res.product, 20));
          }
        }
      }
    });
  }

  function loadMapIndex(zoom) {
    var urlIndex = new URL(window.location.href);
    var paramsType = urlIndex.searchParams.get("type");
    $.ajax({
      url: "/products?type=show_map",
      type: 'GET',
      data: {},
      dataType: 'json',
      success: function (res) {
        if (paramsType === 'show_map' && res.products) {
          google.maps.event.addDomListener(window, 'load', initialize(res.products, zoom));
        }
      }
    });
  }

  if(window.location.href === window.location.protocol + "//" + window.location.host + "/products?type=show_map"){
    loadMapIndex(12);
  }

  $(document).off('click', '#zoom-map');
  $(document).on("click", "#zoom-map", function (e) {
    e.preventDefault();
    loadMapIndex(13);
  });
});
