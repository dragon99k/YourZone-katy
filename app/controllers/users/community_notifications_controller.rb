class Users::CommunityNotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.community_notifications.not_seen.order(created_at: :desc)
  end

  def seen
    current_user.community_notifications.not_seen.join_to_event.update_all status: CommunityNotification.statuses[:seen]
  end
end
