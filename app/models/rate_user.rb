class RateUser < ApplicationRecord

  acts_as_paranoid

  belongs_to :user, foreign_key: :rate_user_id, class_name: 'User'

  validates :content, length: 1..200
end
