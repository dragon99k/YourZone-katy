class CommunityMessage < ApplicationRecord
  belongs_to :community_room
  belongs_to :user

  acts_as_paranoid


  has_attached_file :image, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  scope :order_created_at, -> (last_time, limit = 20) do
    where('community_messages.created_at < ?', last_time)
      .order('community_messages.created_at desc')
      .limit(limit)
  end
end
