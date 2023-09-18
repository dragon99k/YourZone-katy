class Admin::UsersController < Admin::BaseController
  before_action :get_user, except: [:index, :destroy_multi_users, :new, :create]

  def index
    page = params[:page] ? params[:page].to_i : 1
    q = params[:q] || ''
    @users = User.search(q).order(created_at: :desc).page(page).per(20)
  end

  def new
    @user = User.new()
  end

  def create
    user = User.with_deleted.find_by(email: sign_up_params[:email])
    ActiveRecord::Base.transaction do
      if user.present?
        user.update!(status: User.statuses[:active])
        reupdate_relation_by_user user
        redirect_to sex_admin_users_path(sex: user.sex), notice: 'success'
      else
        user = User.new(sign_up_params)
        user.image = File.new("#{Rails.root}/public/images/default.jpg")
        user.confirmed_at = Time.zone.now
        if user.save
          redirect_to sex_admin_users_path(sex: user.sex), notice: 'success'
        else
          render :new
        end
      end
    end
  end

  def show
    image_count = @user.user_images.count

    if image_count < 3
      i = image_count
      while i < 3
        @user.user_images.build
        i += 1
      end
    end
  end

  def block
    if @user.deleted_at
      @user.restore(recursive: true)
    else
      @user.destroy
    end

    respond_to do |format|
      format.js
    end
  end

  def update
    if @user.update(user_params)
      if @user.user_images.present?
        @user.image = @user.user_images.first.image
      else
        @user.image = nil
      end
      @user.confirmed_at = Time.zone.now
      @user.save

      redirect_to sex_admin_users_path(sex: @user.sex), notice: 'プロフィールが更新されました。'
    else
      render :show
    end
  end

  def destroy_multi_users
    return unless params[:arr_user_id].size > 0
    users = User.where(id: params[:arr_user_id])
    destroy_users users

    respond_to do |format|
      format.js
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: '削除成功'
    end
  end

  private

  def get_user
    @user = User.with_deleted.find(params[:id])
    redirect_to sex_admin_users_path(sex: @user.sex) if @user.email == "master_admin@eventmatching.com"
  end

  def user_params
    birthday = params[:day].to_s + '-' + params[:month].to_s + '-' + params[:year].to_s
    params[:user][:birthday] = birthday

    params.require(:user).permit(
        :nickname, :name, :email, :sex, :birthday, :self_introduction, :blood_type, :siblings, :nationality,
        :birth_place, :residence, :academic, :industry, :height, :industry, :body_type,
        user_images_attributes: [:id, :image, :_destroy]
    )
  end

  def sign_up_params
    birthday = params[:day].to_s + '-' + params[:month].to_s + '-' + params[:year].to_s
    params[:user][:birthday] = birthday

    params.require(:user).permit(:nickname, :email, :password, :password_confirmation, :sex, :residence, :birthday)
  end

  def destroy_users users
    return unless users.size > 0
    users.each do |user|
      ActiveRecord::Base.transaction do
        user.update(status: User.statuses[:inactive])
        destroy_relation_by_user user
      end
    end
  end

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
