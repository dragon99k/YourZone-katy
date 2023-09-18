class Chatroom < ApplicationRecord
  has_many :messages
  belongs_to :user1, foreign_key: :user1_id, class_name: 'User'
  belongs_to :user2, foreign_key: :user2_id, class_name: 'User'
  has_one :last_message, -> { order created_at: :desc }, foreign_key: :chatroom_id, class_name: 'Message'

  acts_as_paranoid

  validate :check_user, on: :create

  scope :list_by_user, -> (user_id) do
    includes(:user1, :user2, :last_message)
        .where('user1_id = ? OR user2_id = ?', user_id, user_id)
  end

  scope :not_blocks, -> (user) do
    block_user_ids = user.block_user_ids

    where.not(user1_id: block_user_ids)
        .where.not(user2_id: block_user_ids)
  end

  def self.check_present(user1_id, user2_id)
    where(user1_id: user1_id, user2_id: user2_id)
        .or(where(user1_id: user2_id, user2_id: user1_id)).first
  end

  private

  def check_user
    chatroom = Chatroom.check_present user1_id, user2_id

    errors.add(:user1_id, "is not exit") if chatroom.present?
  end
end
