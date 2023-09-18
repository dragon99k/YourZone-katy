class Admin::ChatroomsController < Admin::BaseController
  before_action :get_chatroom, except: :index

  def index
    page = params[:page] ? params[:page].to_i : 1
    @chatrooms = Chatroom.includes(:user1, :user2, :last_message).order(:created_at).page(page).per(20)
  end

  def show
    page = params[:page] ? params[:page].to_i : 1
    @messages = @chatroom.messages.order('messages.created_at').page(page).per(20)
  end

  private

  def get_chatroom
    @chatroom = Chatroom.find(params[:id])
  end
end
