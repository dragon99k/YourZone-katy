class Admin::MessagesController < Admin::BaseController

  def index
    page = params[:page] ? params[:page].to_i : 1
    @messages = Message.all.order(created_at: :desc).page(page).per(DEFAULT_PER_PAGE)
  end

  
end
