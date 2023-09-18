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
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require bootstrap
//= require bootstrap-sprockets
//= require slick.min
//= require core
//= require cable
//= require chatrooms
//= require channels/chatrooms
//= require communities
//= require search
//= require users
//= require profiles
//= require products
//= require community_topics
//= require channels/community_rooms
//= require user_blocker
//= require notifications
//= require crop_images
//= require report_users

$(document).on('turbolinks:load', function() {
  if ($('#toast').length > 0) {
    $('#toast').addClass('show');

    setTimeout(function(){ $('#toast').removeClass('show') }, 4000);
  }
});
