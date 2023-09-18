class PushNotificationsController < ApplicationController
  before_action :authenticate_user!

  def save_token
    token = params[:token]
    hasToken = UserNotifyAuthentication.where(user_id: params[:user_id]).where(token: token.to_s).first

    unless hasToken
      data = {
        user_id: params[:user_id],
        token: token.to_s
      }
      newToken = UserNotifyAuthentication.new(data)
      newToken.save!
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy_token
    token = UserNotifyAuthentication.where(user_id: params[:user_id], token: params[:token]).first
    if token
      token.destroy
    end
    respond_to do |format|
      format.html
      format.js
    end

  end

end
