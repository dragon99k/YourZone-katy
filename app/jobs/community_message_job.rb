class CommunityMessageJob < ApplicationJob
  queue_as :default

  def perform(message, community_room, is_after, current_user, community)
    ActionCable.server.broadcast "community_rooms:#{message.community_room_id}", {
      message: render_message(message, community_room, is_after, current_user),
      community_room_id: message.community_room_id,
      from_user_id: current_user.id
    }
  end

  private

  def render_message message, community_room, is_after, current_user
    renderer = ApplicationController.renderer_with_signed_in_user(current_user)

    renderer.render(
      partial: 'community_messages/message',
      locals: { message: message, community_room: community_room, is_after: is_after }
    )
  end

  def send_notification(message, receiver, community_room_id)
    if receiver&.notification&.notification_type == "turn_on_notificaton" || receiver&.notification.nil?
      api_key = "AAAAIag5n60:APA91bGJqnvQ5eKg1NY1HIVs-pMcR0X0Avs8GIqWYHtRz5Tmmn8gEcEHogzvY6NuH2EPMxWlv88gV5bvbL8J03wwn5wGzbsqpmazHKwHv2nifqbKxMIfwlUXQLu0YhVPIF2tTxe0PNhB"
      fcm = FCM.new(api_key)

      setting = UserNotifyAuthentication.where(user_id: receiver&.id)
      registration_tokens = setting.map(&:token)
      title = message&.body
      content = ""

      url = "#{ENV['BASE_URL']}/communities/#{community_room_id}"

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
