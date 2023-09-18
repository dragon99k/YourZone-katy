class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_or_create_notifications, only: [:index, :update]

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    redirect_to notifications_path() if @notification.update_attributes!(notification_params)
  end

  private

  def find_or_create_notifications
    @notification = Notification.find_or_create_by(user_id: current_user.id)
  end

  def notification_params
    params[:notification][:like_type] = params[:notification][:like_type].to_i
    params[:notification][:message_type] = params[:notification][:message_type].to_i
    params[:notification][:notification_type] = params[:notification][:notification_type].to_i
    params.require(:notification).permit(:like_type, :message_type, :notification_type, :user_id)
  end
end
