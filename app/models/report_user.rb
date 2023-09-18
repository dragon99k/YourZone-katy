class ReportUser < ApplicationRecord

  acts_as_paranoid

  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true

  scope :search, -> (key) {
    where("title LIKE ? or content LIKE ?", "%#{key}%", "%#{key}%")
  }
end
