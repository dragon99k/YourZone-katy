class Like < ApplicationRecord
  belongs_to :user
  belongs_to :like_user, foreign_key: :like_user_id, class_name: 'User'

  acts_as_paranoid
end
