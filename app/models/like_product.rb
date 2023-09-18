class LikeProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product

  acts_as_paranoid
end
