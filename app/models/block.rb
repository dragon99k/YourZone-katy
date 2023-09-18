class Block < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :block_user, foreign_key: :block_user_id, class_name: 'User'
end
