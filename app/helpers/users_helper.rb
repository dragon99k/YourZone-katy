module UsersHelper
  def years
    (1960..2005).to_a.map {|year| ["#{year}年", year]}
  end


  def months
    (1..12).to_a.map {|month| ["#{month}月", month]}
  end

  def days
    (1..31).to_a.map {|day| ["#{day}日", day]}
  end

  def provinces
    User::PROVINCES.each_with_index.map do |province, index|
      [province, index]
    end
  end

  def genders
    [["未設定", ''], ["男性", 1], ["女性", 2]]
  end

  def has_user_wait_to_approve_community user_id
    Favorite.list_user_wait_to_approve_community(user_id).present?
  end
end
