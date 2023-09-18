module ApplicationHelper
  def provinces
    User::PROVINCES.each_with_index.map do |province, index|
      [province, index]
    end
  end

  def category_list
    Community::CATEGORY.each_with_index.map do |category, index|
      [category, index]
    end
  end

  def category_product
    Product::CATEGORY.each_with_index.map do |category, index|
      [category, index]
    end
  end

  def format_short_day time
    return unless time.present?
    time.strftime("%-m/%-d")
  end

  def join_community_btn_text(community)
    return t('join_community_btn.join_community') if community.user_ids.exclude?(current_user.id)
      
    if community.approved_favorites.pluck(:user_id).include?(current_user.id)
      t('join_community_btn.approved')
    else
      t('join_community_btn.waiting_approve')
    end
  end

  def join_community_class(community)
    return 'not_joined' if community.user_ids.exclude?(current_user.id)
      
    if community.approved_favorites.pluck(:user_id).include?(current_user.id)
      'approved'
    else
      'waiting_approve'
    end
  end
end
