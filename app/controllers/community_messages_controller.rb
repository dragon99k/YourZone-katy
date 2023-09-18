class CommunityMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community_room

  def create
    last_message = @community_room.last_message
    is_after = last_message && last_message.user_id == current_user.id
    message = @community_room.community_messages.new(message_params)
    message.user = current_user
    message.save

    community_topic = Community.find_by(id: params[:community_topic_id])
    CommunityMessageJob.perform_later(message, @community_room, is_after, current_user, community_topic)

    @message = message

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_community_room
    @community_room = CommunityRoom.find_by(community_topic_id: params[:community_topic_id])
    redirect_to root_path if @community_room.blank?
  end

  def message_params
    params.require(:community_message).permit(:body, :image)
  end
end
