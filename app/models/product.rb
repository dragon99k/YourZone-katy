class Product < ApplicationRecord
  PROVINCES = ['北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県',
               '千葉県','東京都', '神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県',
               '滋賀県','京都府','大阪府', '兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県',
               '愛媛県','高知県','福岡県','佐賀県', '長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県','海外']
  CATEGORY = ['モノ','コト']

  acts_as_paranoid

  has_many :product_images, dependent: :destroy
  belongs_to :user, foreign_key: :product_user_id, class_name: 'User'
  has_many :like_products, foreign_key: :product_id, class_name: 'LikeProduct', dependent: :destroy
  has_many :users, through: :like_products
  has_many :exchange_items, foreign_key: :product_id, class_name: 'ExchangeItem', dependent: :destroy

  # validates :image, presence: {message: "画像をアップロードしてください。"}
  validates :title, presence: {message: "タイトルを入力してください。"}
  validates :description, presence: {message: "概要を入力してください。"}

  enum product_type: {not_exchange: 0, exchange: 1}
  enum status: {not_stop: 0, stop: 1}

  accepts_nested_attributes_for :product_images, allow_destroy: true

  has_attached_file :image, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  scope :order_list, -> (residence) {
    where(residence: residence)
  }

  scope :search, -> (key) {
    not_exchange.where("title LIKE ? or description LIKE ?", "%#{key}%", "%#{key}%")
  }

  scope :not_stop, -> {
    where(status: 0)
  }

  scope :stop, -> {
    where(status: 1)
  }

  scope :join_like_products, -> {
    left_joins(:like_products)
      .select('products.*, GROUP_CONCAT(like_products.user_id) AS user_ids, count(like_products.product_id) AS favorites_count')
      .group('products.id')
  }

  scope :user_like_products, -> (user_id){
    join_like_products.joins(:like_products).where("like_products.user_id = ?", user_id)
  }

  scope :search_have_residence, -> (key, key1) {
    where("title LIKE ? or description LIKE ? or residence = ?", "%#{key}%", "%#{key}%", key1)
  }

  scope :get_item_by_user, -> (user_id){
    join_like_products.where(product_user_id: user_id, product_type: 0)
  }

  scope :user_exchange_item, -> (user_id){
    join_like_products.joins(:exchange_items).includes(:users, :user).where('exchange_items.user_id = ?', user_id)
  }

  def get_user_give
    self.exchange_items&.success_change&.first.user.nickname
  end

  def self.get_province i
    return unless i.present?

    Product::PROVINCES[i]
  end

  def self.get_category i
    return unless i.present?

    Product::CATEGORY[i]
  end

end
