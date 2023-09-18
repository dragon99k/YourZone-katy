class Community < ApplicationRecord
  CATEGORY = %w[文化・芸術系 教育 衣料 飲食 美容] 
  has_many :favorites
  has_many :users, through: :favorites
  has_many :community_images, dependent: :destroy
  belongs_to :user, foreign_key: :community_user_id, class_name: 'User'
  has_many :community_topics, foreign_key: :community_id, class_name: 'CommunityTopic', dependent: :destroy
  has_many :approved_favorites, -> { where(status: Favorite.statuses[:approve]) }, class_name: 'Favorite'
  has_many :notifications, foreign_key: :community_id, class_name: 'CommunityNotification'
  has_one :approving_notification, -> { where(notification_type: 1, status: 0).order(id: :desc) }, class_name: 'CommunityNotification'

  acts_as_paranoid

  accepts_nested_attributes_for :community_images, allow_destroy: true

  validates :name, presence: true
  validates :category, presence: true
  validates :remuneration, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_attached_file :image, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  enum location: I18n.t('prefectures')

  scope :join_favorites, -> {
    left_joins(:favorites)
      .select('communities.*, GROUP_CONCAT(favorites.user_id) AS user_ids, SUM(CASE WHEN favorites.status = 1 THEN 1 ELSE 0 END) AS favorites_count')
      .group('communities.id')
  }

  scope :popularity, -> {
    join_favorites.order('favorites_count DESC')
  }

  scope :recommend, -> {
    join_favorites.order('created_at DESC')
  }

  scope :search, -> (key) {
    where("name LIKE ? or description LIKE ?", "%#{key}%", "%#{key}%")
  }

  scope :search_have_category, -> (key, key1) {
    where("name LIKE ? or description LIKE ? or category = ?", "%#{key}%", "%#{key}%", key1)
  }

  scope :user_like_communities, -> (user_id){
    join_favorites.where("favorites.user_id = ?", user_id)
  }

  scope :user_join_communities, -> (user_id, key){
    left_joins(:favorites, :community_topics).select('communities.*, GROUP_CONCAT(favorites.user_id) AS user_ids,
    SUM(CASE WHEN favorites.status = 1 THEN 1 ELSE 0 END) AS favorites_count,
    GROUP_CONCAT(community_topics.updated_at ORDER BY community_topics.updated_at DESC) AS updated_at_sort')
    .group('communities.id')
    .where("favorites.user_id = ? AND (communities.name LIKE ? OR communities.description LIKE ?)", user_id, "%#{key}%", "%#{key}%")
  }


  def self.get_category i
    return unless i.present?

    Community::CATEGORY[i]
  end
end
