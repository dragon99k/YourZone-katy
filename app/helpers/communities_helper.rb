module CommunitiesHelper
  def has_communities community_id, user_id
    Favorite.find_by(user_id: user_id, community_id: community_id, status: 0).present?
  end

  def month_collations
    (1..12).to_a.map do |month|
      ["#{month}月", month]
    end
  end
end
