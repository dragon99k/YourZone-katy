class CommunityRoom < ApplicationRecord
  has_many :community_messages, foreign_key: :community_room_id, class_name: 'CommunityMessage'
  has_one :last_message, -> { order created_at: :desc }, foreign_key: :community_room_id, class_name: 'CommunityMessage'
  belongs_to :community_topic

  acts_as_paranoid

  private
end
