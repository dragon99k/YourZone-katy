class ChatroomsController < ApplicationController
  before_action :authenticate_user!

  before_action :get_chatroom, only: :show

  def index
    # @user = current_user

    # chatrooms = Chatroom.not_blocks(@user).list_by_user(@user.id)
    # new_lists = []
    # chatrooms.each_with_index do |chatroom, i|
    #   next if chatroom&.last_message.nil?
    #   new_lists << chatroom if i == 0
    #   if chatroom.last_message.created_at > new_lists.last.last_message.created_at
    #     new_lists << chatroom
    #   else
    #     new_lists.insert(0, chatroom)
    #   end
    # end

    @chatrooms = Chatroom.not_blocks(current_user).list_by_user(current_user.id).includes(:last_message).order('messages.created_at DESC')
  end

  def create
    user_id = params[:user_id]
    @chatroom = Chatroom.check_present current_user.id, user_id

    if @chatroom.nil?
      @chatroom = Chatroom.create!(user1_id: current_user.id, user2_id: user_id.to_i)
    end

    redirect_to chatroom_path(@chatroom)
  end

  def show
    @user = current_user
    last_id = params[:last_id]
    last_time = Time.now
    if last_id
      last_message = Message.find_by(id: last_id)
      last_time = last_message.created_at
    end

    @messages = @chatroom.messages.order_created_at(last_time).reverse
    update_messages(@messages) if @messages.present?
    @count = (@count.present? && @count > 1) ? (@count - 1) : nil

    user1 = @chatroom.user1
    user2 = @chatroom.user2
    if user1 == @user
      @from_user = user1
      @to_user = user2
    else
      @from_user = user2
      @to_user = user1
    end

    @products = Product.get_item_by_user(@to_user.id).order(created_at: :desc)

    @exchange_item = ExchangeItem.where(from_user_id: current_user.id, user_id: @to_user.id, exchange_type: "request_change").last

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def get_chatroom
    @chatroom = Chatroom.not_blocks(current_user).list_by_user(current_user.id).find_by(id: params[:id])

    redirect_to root_path if @chatroom.blank?
  end

  def update_messages messages
    messages.each do |msg|
      msg.update!(status: Message.statuses[:read])
    end
  end
end
