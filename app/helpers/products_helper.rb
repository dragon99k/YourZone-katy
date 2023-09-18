module ProductsHelper
  def format_short_date time
    return unless time.present?
    time.strftime("%Y年%m月%-d日")
  end

  def format_messages messages, to_user
    exchange_item = ExchangeItem.where(user_id: current_user.id, from_user_id: to_user.id).last
    user_name_1 = exchange_item.present? ? current_user.nickname : to_user.nickname
    user_name_2 = exchange_item.present? ? to_user.nickname : current_user.nickname
    if messages.include?("さんが交換申請を送信しました。")
      mess = ("-----#{user_name_1}さんが交換申請を送信しました。-----").truncate(25)
    elsif messages.include?("さんが交換申請を承認しました。")
      mess = ("-----#{user_name_2}さんが交換申請を承認しました。-----").truncate(25)
    elsif messages.include?("さんが交換申請を拒否しました。")
      mess = ("-----#{user_name_2}さんが交換申請を拒否しました。-----").truncate(25)
    else
      mess = messages.truncate(30)
    end
    mess
  end
end
