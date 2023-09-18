class SendNotificationJoinGroup < ApplicationJob
  queue_as :default

  def perform(user_id, login_user_id, title)
    receiver_user = User.find_by(id: login_user_id.to_i)
    user = User.find_by(id: user_id.to_i)
    send_notification(receiver_user, user, title)
  end

  private
  def send_notification(receiver, user, title)
    if user&.notification&.notification_type == "turn_on_notificaton" || user&.notification.nil?
      api_key = "AAAAIag5n60:APA91bGJqnvQ5eKg1NY1HIVs-pMcR0X0Avs8GIqWYHtRz5Tmmn8gEcEHogzvY6NuH2EPMxWlv88gV5bvbL8J03wwn5wGzbsqpmazHKwHv2nifqbKxMIfwlUXQLu0YhVPIF2tTxe0PNhB"
      fcm = FCM.new(api_key)

      setting = UserNotifyAuthentication.where(user_id: user&.id)
      registration_tokens = setting.map(&:token)
      content = ""

      url = "#{ENV['BASE_URL']}users/#{receiver.id}"

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
