class Notification < ApplicationRecord
  acts_as_paranoid

  belongs_to :user

  enum like_type: { turn_on_like: 0, turn_off_like: 1}
  enum message_type: { turn_on_message: 0, turn_off_message: 1}
  enum notification_type: { turn_on_notificaton: 0, turn_off_notificaton: 1}
end
