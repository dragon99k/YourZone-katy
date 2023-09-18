class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chatroom

  def create
    last_message = @chatroom.last_message
    is_after = last_message && last_message.user_id == current_user.id
    message = @chatroom.messages.new(message_params)
    message.user = current_user
    message.save

    user_id = @chatroom.user1_id == current_user&.id ? @chatroom.user2_id : @chatroom.user1_id
    MessageRelayJob.perform_later(message, @chatroom, is_after, current_user, user_id)
  end

  def destroy
    message = Message.find_by(chatroom_id: params[:chatroom_id], id: params[:id])
    if message.user_id == current_user.id && message.destroy
      redirect_to chatroom_path(id: params[:chatroom_id]), notice: 'success'
    end
  end

  private

  def set_chatroom
    @chatroom = Chatroom.find(params[:chatroom_id])
    redirect_to root_path if @chatroom.blank?
  end

  def message_params
    params.require(:message).permit(:body, :image)
  end
end
