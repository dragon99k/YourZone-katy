class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :count_messages

  def self.renderer_with_signed_in_user(user)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap { |i|
      i.set_user(user, scope: :user, store: false, run_callbacks: false)
    }
    renderer.new('warden' => proxy)
  end

  def after_sign_in_path_for(resource)
    if action_name == "create" && params[:user].present?
      if resource.admin?
        sign_out(resource)
        admin_root_path
      else
        root_path
      end
    end
  end

  private
  def count_messages
    chat_rooms = Chatroom.where("user1_id = ? OR user2_id = ?", current_user&.id, current_user&.id)
    count = 0
    chat_rooms.each do |chat_room|
      user_id = chat_room.user1_id == current_user&.id ? chat_room.user2_id : chat_room.user1_id
      count_message = chat_room.messages.where(user_id: user_id, status: Message.statuses[:un_read]).size
      count += 1 if count_message >= 1
    end
    @count = count if count > 0
  end

  def update_image_user
    unless current_user.image.present?
      current_user.image = File.new("#{Rails.root}/public/images/default.jpg")
      current_user.save!
    end
  end
end
