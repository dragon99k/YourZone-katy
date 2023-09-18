App.community_rooms = App.cable.subscriptions.create "CommunityRoomsChannel",
  connected: ->
    console.log('connected')
# Called when the subscription is ready for use on the server

  disconnected: ->
    console.log('disconnected')
# Called when the subscription has been terminated by the server

  received: (data) ->
    message = data.message;
    active_chatroom = $("[data-behavior='community_messages'][data-community-room-id='#{data.community_room_id}']")

    if active_chatroom.length > 0
      current_user_id = active_chatroom.data('user-id');

      active_chatroom.slice(-1).append(message)
      active_chatroom.slice(-1).parent().scrollTop(active_chatroom.slice(-1).prop('scrollHeight'))
      $('#new-community-message').focus()
    else
      $("[data-behavior='community_messages'][data-community-room-id='#{data.community_room_id}']").css("font-weight", "bold")
# Called when there's incoming data on the websocket for this channel
