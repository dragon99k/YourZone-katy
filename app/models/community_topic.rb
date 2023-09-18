class CommunityTopic < ApplicationRecord
  belongs_to :community
  has_many :community_topic_images, dependent: :destroy
  has_one :community_room, foreign_key: :community_topic_id, class_name: 'CommunityRoom'
  belongs_to :user

  acts_as_paranoid

  accepts_nested_attributes_for :community_topic_images, allow_destroy: true

  validates :title, presence: true

  has_attached_file :image, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
