class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :community

  acts_as_paranoid

  enum status: {wait_approve: 0, approve: 1}

  scope :list_user_wait_to_approve_community, -> (user_id) do
    joins(:community).where("communities.community_user_id = ? AND favorites.user_id != ? AND favorites.status = ?", user_id, user_id, Favorite.statuses[:wait_approve])
  end
end
