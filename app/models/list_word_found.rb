class ListWordFound < ApplicationRecord

  acts_as_paranoid

  validates :word, presence: true, uniqueness: true

  scope :search, -> (key) {
    where("word LIKE ?", "%#{key}%")
  }
end
