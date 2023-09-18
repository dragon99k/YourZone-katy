App.chatrooms = App.cable.subscriptions.create "ChatroomsChannel",
  connected: ->
    console.log('connected')
    # Called when the subscription is ready for use on the server

  disconnected: ->
    console.log('disconnected')
    # Called when the subscription has been terminated by the server

  received: (data) ->
    from_user_id = data.from_user_id;
    message = data.message;
    product_id = data.product_id;
    exchange_id = data.exchange_item_id;
    active_chatroom = $("[data-behavior='messages'][data-chatroom-id='#{data.chatroom_id}']")

    if active_chatroom.length > 0
      current_user_id = active_chatroom.data('user-id');
      if from_user_id && current_user_id && product_id && exchange_id
        if from_user_id != current_user_id
          $(".btn-exchange").css("display", "none")
          $(".btn-exchange-complete").css("display", "block")
          $(".btn-exchange-reject").css("display", "block")
          $("#nick-name").addClass("confirm")
          $('.btn-exchange-complete').attr('data-product', parseInt(product_id));
          $('.btn-exchange-complete').attr('data-exchange', parseInt(exchange_id));
          $('.btn-exchange-reject').attr('data-product', parseInt(product_id));
          $('.btn-exchange-reject').attr('data-exchange', parseInt(exchange_id));
        else
          $('.btn-exchange').prop('disabled', true);
      else if from_user_id != current_user_id && product_id == "" && exchange_id == ""
        index = message.indexOf('right');
        if index > -1
          message = message.substr(0, index) + 'left' + message.substr(index + 5);
        else
          window.location.reload()
          $('.btn-exchange').prop('disabled', false);
      active_chatroom.append(message)
      active_chatroom.parent().scrollTop(active_chatroom.prop('scrollHeight'))
      $('#new_message').focus()

    else
      if(window.location.pathname == "/chatrooms")
        window.location.reload()
      else
        $("#global-navi").find(".alert-new").css("display", "block")
      $("[data-behavior='chatroom-link'][data-chatroom-id='#{data.chatroom_id}']").css("font-weight", "bold")
      # Called when there's incoming data on the websocket for this channel
