class User < ApplicationRecord
  PROVINCES = ['北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県',
               '千葉県','東京都', '神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県',
               '滋賀県','京都府','大阪府', '兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県',
               '愛媛県','高知県','福岡県','佐賀県', '長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県','海外']

  REGEX_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  acts_as_paranoid

  before_validation :set_image

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter, :line, :instagram]

  has_many :user_images, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :communities, through: :favorites
  has_many :follows, dependent: :destroy
  has_many :followers, foreign_key: :follow_user_id, class_name: 'Follow', dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :user_likes, foreign_key: :like_user_id, class_name: 'Like', dependent: :destroy
  has_many :host_chatrooms, foreign_key: :user1_id, class_name: 'Chatroom', dependent: :destroy
  has_many :guest_chatrooms, foreign_key: :user2_id, class_name: 'Chatroom', dependent: :destroy
  has_many :visits, dependent: :destroy
  has_many :visiters, foreign_key: :visit_user_id, class_name: 'Visit',  dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :blockers, foreign_key: :block_user_id, class_name: 'Block',  dependent: :destroy
  has_many :products, foreign_key: :product_user_id, class_name: 'Product',  dependent: :destroy
  has_many :rate_users, foreign_key: :rate_user_id, class_name: 'RateUser',  dependent: :destroy
  has_many :communities, foreign_key: :community_user_id, class_name: 'Community', dependent: :destroy
  has_many :community_messages, dependent: :destroy
  has_many :like_products, dependent: :destroy
  has_many :products, through: :like_products
  has_many :community_topics, foreign_key: :user_id, class_name: 'CommunityTopic', dependent: :destroy
  has_many :exchange_items, foreign_key: :user_id, class_name: 'ExchangeItem', dependent: :destroy
  has_one :notification, dependent: :destroy
  has_many :report_users, dependent: :destroy
  has_many :community_notifications

  accepts_nested_attributes_for :user_images, allow_destroy: true

  validates :email, presence: true, uniqueness: true
  validates :nickname, presence: true
  validates :image, presence: true

  has_attached_file :image, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  do_not_validate_attachment_file_type :image

  enum blood_type: { blood_a: 0, blood_b: 1, blood_ab: 2, blood_o: 3 }
  enum academic: { high_school: 0, junior_college: 1, university: 2, graduate: 3, academic_other: 4 }
  enum industry: { hairdresser: 0, developer: 1, manager: 2 }
  enum body_type: { slim: 0, slightly_thin: 1, usually: 2, muscular: 3, slightly_chubby: 4, thick: 5 }
  enum sex: { male: 0, female: 1 }
  enum status: { inactive: 0, active: 1 }
  enum user_type: { normal: 0, admin: 1 }

  scope :join_favorites, -> {
    left_joins(:favorites)
        .select('users.*, count(favorites.user_id) AS favorites_count')
        .group('users.id')
  }

  scope :join_likes, -> {
    left_joins(:likes)
      .select('users.*, count(likes.user_id) AS favorites_count')
      .group('users.id')
  }

  scope :search, -> (key) {
    join_favorites.where("name LIKE ? or nickname LIKE ?", "%#{key}%", "%#{key}%")
  }

  scope :seach_and_like_count, -> (key) {
    join_likes.where("name LIKE ? or nickname LIKE ? or email LIKE ? or self_introduction LIKE ?
      or siblings LIKE ? or nationality LIKE ? or siblings LIKE ? or height LIKE ?
      or interest LIKE ? or instagram_url LIKE ? or facebook_url LIKE ? or youtube_url LIKE ?", "%#{key}%", "%#{key}%",
      "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%",)
  }

  scope :not_blocks, -> (user) {
    block_user_ids = user.block_user_ids
    where.not(id: block_user_ids)
  }

  scope :user_genders, ->(user) {
    sex = user.male? ? 1 : 0
    not_blocks(user).where(sex: sex)
  }

  scope :not_user, -> (user) {
    where.not(id: user.id)
  }

  scope :get_visiters, -> (user_id, last_days = 7) do
    last_time = Time.now - last_days.days

    joins(:visiters)
        .select('users.*, Max(visits.created_at) as last_visit_at')
        .where('visits.user_id = ? AND visits.created_at >= ?', user_id, last_time)
        .group('users.id')
        .order('last_visit_at DESC')
  end

  scope :list_by_user, -> (user_id) do
        where('user1_id = ? OR user2_id = ?', user_id, user_id)
  end

  scope :user_likes_me, -> (user_id) do
    join_favorites.joins(:user_likes).where("likes.user_id = ?", user_id)
  end

  scope :my_user_likes, -> (user_id) do
    join_favorites.joins(:likes).where("likes.like_user_id = ?", user_id)
  end

  scope :count_user_join_community, -> (current_user) {
    left_joins(:favorites).not_blocks(current_user).where("favorites.status = 1").uniq
  }

  def block_user_ids
    blocks.pluck(:block_user_id) + blockers.pluck(:user_id)
  end

  def age
    return if birthday.nil?

    age = Date.today.year - birthday.year
    age -= 1 if Date.today < birthday + age.years
    age
  end

  def chatrooms
    Chatroom.where('user1_id = ? OR user2_id = ?', id, id)
  end

  def set_image
    unless self&.image&.content_type =~ /\Aimage\/.*\Z/
      Paperclip::DataUriAdapter.register
      Paperclip.io_adapters.for(self.image) do |data|
        data.class.class_eval { attr_accessor :original_filename, :content_type }
        data.original_filename = "product_#{self.title}.jpg"
        data.content_type = "image/jpeg"
        self.image = data
      end
    end
  end

  def self.get_province i
    return unless i.present?

    User::PROVINCES[i]
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
