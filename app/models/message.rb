class Message < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user

  acts_as_paranoid

  enum status: {un_read: 0, read: 1}
  enum message_type: {text: 0, text_item: 1, image_item: 2}

  has_attached_file :image, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  scope :order_created_at, -> (last_time, limit = 20) do
    where('messages.created_at < ?', last_time)
        .order('messages.created_at desc')
        .limit(limit)
  end

  def receiver
    ([chatroom.user1] + [chatroom.user2] - [user]).first
  end
end
