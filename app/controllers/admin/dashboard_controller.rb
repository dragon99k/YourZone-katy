class Admin::DashboardController < Admin::BaseController
  def index
    data_exchange_item
    data_user_hash
    data_group_hash
    data_product_hash
    data_total

    respond_to do |f|
      f.html
      f.js
      f.json { render :json => {data_exchange_items: data_exchange_item,
                                user_hash: data_user_hash,
                                group_hash: data_group_hash,
                                product_hash: data_product_hash}}
    end
  end

  private

  def data_exchange_item
    exchange_items_by_year = ExchangeItem.where(exchange_type: 2, updated_at: [Time.zone.now.beginning_of_year..Time.zone.now.end_of_year])
                                         .group_by { |m| m.updated_at.month }
    exchange_items_by_year.each do |month, exchange_items|
      data_by_year_hash << { month: month, value: exchange_items.count}
    end
    data_by_year_hash
  end

  def data_by_year_hash
    data_array = []
    Date::MONTHNAMES.slice(1..-1).each do |month|
      data_array << { month: Date::MONTHNAMES.index(month), value: 0 }
    end
    @data_by_year_hash ||= data_array
  end

  def data_user_hash
    @data_user_hash = [
      {sex: "Male", total: User.male.count},
      {sex: "Female", total: User.female.count}
    ]
  end

  def data_group_hash
    data_array = []
    all_group_by_category = Community.group(:category).count
    all_group_by_category.each do |data|
      data_array << {category: Community::CATEGORY[data[0]], count: data[1]}
    end
    @data_group_hash ||= data_array
  end

  def data_product_hash
    data_array = []
    all_product_by_category = Product.group(:category).count
    all_product_by_category.each do |data|
      data_array << {category: Product::CATEGORY[data[0]], count: data[1]}
    end
    @data_product_hash ||= data_array
  end

  def data_total
    @data_total = {user_count: User.count, product_count: Product.count, group_count: Community.count, exchange_item_count: ExchangeItem.success_change.count}
  end
end
