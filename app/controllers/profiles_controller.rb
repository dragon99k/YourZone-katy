class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @follow = @user.follows.find_by(follow_user_id: @user.id)
    communities = @user.communities.order(created_at: :desc).limit(3)
    products_exchanges = Product.user_exchange_item(current_user.id).order(created_at: :desc)
    products = Product.join_like_products.where(product_user_id: current_user.id).order(created_at: :desc)
    @data = {products_exchanges: products_exchanges, products: products, communities: communities}

    render 'users/show'
  end

  def edit
    @user = current_user
    image_count = @user.user_images.count

    while image_count < 5
      @user.user_images.build
      image_count += 1
    end
  end

  def update
    @user = current_user

    @user.assign_attributes(user_params)
    @user.user_images.each do |user_image|
      user_image.set_image
    end
    if @user.save
      redirect_to profile_path, notice: 'プロフィールが更新されました。'
    else
      render :edit
    end
  end

  def visits
    page = params[:page] ? params[:page].to_i : 1
    @users = User.not_blocks(current_user).get_visiters(current_user.id).page(page).per(10)

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def user_params
    birthday = params[:day].to_s + '-' + params[:month].to_s + '-' + params[:year].to_s
    params[:user][:birthday] = birthday

    params[:user][:facebook_url] = params[:facebook_id].present? ? "https://www.facebook.com/" + params[:facebook_id].to_s : ""
    params[:user][:instagram_url] = params[:instagram_id].present? ? "https://www.instagram.com/" + params[:instagram_id].to_s : ""
    params[:user][:youtube_url] = params[:youtube_id].present? ? "https://www.youtube.com/channel/" + params[:youtube_id].to_s : ""


    params.require(:user).permit(
        :nickname, :name, :email, :sex, :birthday, :self_introduction, :blood_type, :siblings, :nationality,
        :birth_place, :residence, :academic, :industry, :height, :industry, :body_type, :interest, :facebook_url,
        :instagram_url, :youtube_url, :image,
        user_images_attributes: [:id, :image_topic, :_destroy]
    )
  end
end
