class AdminNotification < ApplicationRecord
  acts_as_paranoid

  validates :title, presence: true
  validates :content, presence: true

  scope :search, -> (key) {
    where("title LIKE ? or content LIKE ?", "%#{key}%", "%#{key}%")
  }
end
