module Admin::ApplicationHelper
  def favorite_count_for_community community
    if  community.present? && community.user.present?
      count = community.users.join_favorites.not_blocks(community.user).to_a.count
      count
    else
      0
    end
  end

  def resource_name
    :user
  end

  def check_time_password
    Admin.first.updated_at + 5.minutes > Time.zone.now
  end

  def active_class(menu_name)
    'active' if menu_name == controller_name
  end
end
