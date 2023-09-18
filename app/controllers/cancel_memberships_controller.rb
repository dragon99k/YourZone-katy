class CancelMembershipsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:check_user_for_login, :update_user_active]

  def update
    ActiveRecord::Base.transaction do
      user = User.find_by(id: params[:id])
      if user.update(status: User.statuses[:inactive])
        destroy_relation_by_user user
        sign_out(user)
        redirect_to root_path
      else
        redirect_to profile_path
      end
    end
  end

  def update_user_active
    is_success = false
    ActiveRecord::Base.transaction do
      user = User.with_deleted.find_by(email: params["email"].to_s)
      if user.present? && user.update(status: User.statuses[:active])
        reupdate_relation_by_user user
        is_success = true
      end
    end

    respond_to do |format|
      format.json { render :json => {data: is_success}}
    end
  end

  def check_user_for_login
    is_inactive = false
    if params["email"].present?
      user = User.with_deleted.find_by(email: params["email"].to_s)
      if User.find_by(email: params["email"].to_s).nil? && user.present? && user.status == "inactive"
        is_inactive = true
      end
    else
      is_inactive = nil
    end
    respond_to do |format|
      format.json { render :json => {data: is_inactive}}
    end
  end

  private
  def destroy_relation_by_user user
    return unless user.present?

    user.destroy
    user.user_images.destroy
    user.favorites.destroy
    user.follows.destroy
    user.followers.destroy
    user.messages.destroy
    user.likes.destroy
    user.user_likes.destroy
    user.host_chatrooms.destroy
    user.guest_chatrooms.destroy
    user.visits.destroy
    user.visiters.destroy
    user.blocks.destroy
    user.blockers.destroy
    user.products.destroy
    user.rate_users.destroy
    user.communities.destroy
    user.community_messages.destroy
    user.like_products.destroy
    user.products.destroy
    user.community_topics.destroy
    user.exchange_items.destroy
    user.notification&.destroy
  end

  def reupdate_relation_by_user user
    return unless user.present?

    user.update(deleted_at: nil)
    user.user_images.update_all(deleted_at: nil)
    user.favorites.update_all(deleted_at: nil)
    user.follows.update_all(deleted_at: nil)
    user.followers.update_all(deleted_at: nil)
    user.messages.update_all(deleted_at: nil)
    user.likes.update_all(deleted_at: nil)
    user.user_likes.update_all(deleted_at: nil)
    user.host_chatrooms.update_all(deleted_at: nil)
    user.guest_chatrooms.update_all(deleted_at: nil)
    user.visits.update_all(deleted_at: nil)
    user.visiters.update_all(deleted_at: nil)
    user.blocks.update_all(deleted_at: nil)
    user.blockers.update_all(deleted_at: nil)
    user.products.update_all(deleted_at: nil)
    user.rate_users.update_all(deleted_at: nil)
    user.communities.update_all(deleted_at: nil)
    user.community_messages.update_all(deleted_at: nil)
    user.like_products.update_all(deleted_at: nil)
    user.products.update_all(deleted_at: nil)
    user.community_topics.update_all(deleted_at: nil)
    user.exchange_items.update_all(deleted_at: nil)
    user&.notification&.update(deleted_at: nil)
  end
end
