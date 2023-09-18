class MessageRelayJob < ApplicationJob
  queue_as :default

  def perform(message, chatroom, is_after, current_user, user_id, product_id = "", exchange_item_id = "")
    ActionCable.server.broadcast "chatrooms:#{message.chatroom_id}", {
        message: render_message(message, chatroom, is_after, current_user),
        chatroom_id: message.chatroom_id,
        from_user_id: current_user.id,
        product_id: product_id,
        exchange_item_id: exchange_item_id,
        to_user_id: user_id
    }

    receiver_user = User.find_by(id: user_id.to_i)
    send_notification(message, receiver_user)
  end

  private

  def render_message message, chatroom, is_after, current_user
    renderer = ApplicationController.renderer_with_signed_in_user(current_user)

    renderer.render(
        partial: 'messages/message',
        locals: { message: message, chatroom: chatroom, is_after: is_after }
    )
  end

  def send_notification(message, receiver)
    if receiver&.notification&.message_type == "turn_on_message" || receiver&.notification.nil?
      api_key = "AAAAIag5n60:APA91bGJqnvQ5eKg1NY1HIVs-pMcR0X0Avs8GIqWYHtRz5Tmmn8gEcEHogzvY6NuH2EPMxWlv88gV5bvbL8J03wwn5wGzbsqpmazHKwHv2nifqbKxMIfwlUXQLu0YhVPIF2tTxe0PNhB"
      fcm = FCM.new(api_key)

      setting = UserNotifyAuthentication.where(user_id: receiver&.id)
      registration_tokens = setting.map(&:token)
      if message&.body.present?
        if message.message_type == "image_item"
          title = "画像が添付されました。"
        else
          title = message&.body
        end
      end
      if message&.image.present?
        title = ("#{message&.body}<br/>画像が添付されました。").html_safe
      end
      content = ""

      url = "#{ENV['BASE_URL']}chatrooms"

      options = {
        notification: {
          title: title,
          body: content,
          tag: SecureRandom.hex(10),
          click_action: url
        }
      }

      fcm.send(registration_tokens, options)
    end
  end
end
