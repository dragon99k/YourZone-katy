# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $(document.body).on 'click', '.open-nav', (e) ->
    openNav()

  $(document.body).on 'click', '.closebtn-sidenav', (e) ->
    closeNav()

  $(document.body).on 'click', '.show-modal-confirm-cancel-membership', (e) ->
    $('.modal-confirm-cancel-membership').css('display', 'block')

  $(document.body).on 'click', '.modal-custom .close-modal', (e) ->
    $('.modal-custom').css('display', 'none')

  openNav = ->
    $('#mySidenav').css 'display', 'block'
    return

  closeNav = ->
    $('#mySidenav').css 'display', 'none'
    return

  return
