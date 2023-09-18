class Visit < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :visit_user, foreign_key: :visit_user_id, class_name: 'User'
end
