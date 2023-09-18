class UsersController < ApplicationController
  before_action :authenticate_user!

  before_action :get_user
  skip_before_action :get_user, only: [:un_block, :user_blockers, :list_user_wait_to_approve_community]

  def show
    @user.visits.create(visit_user_id: current_user.id)
    @follow = @user.follows.find_by(follow_user_id: current_user.id)
    @like = @user.likes.find_by(like_user_id: current_user.id)
    @next_user = User.find(User.pluck(:id).sample)
    products_exchanges = Product.user_exchange_item(@user.id).order(created_at: :desc)
    products = Product.join_like_products.where(product_user_id: @user.id).order(created_at: :desc)
    communities = @user.communities.order(created_at: :desc).limit(3)
    @data = {products_exchanges: products_exchanges, products: products, communities: communities}
  end

  def destroy
    @user.destroy
    redirect_to destroy_user_session_path
  end

  def follow
    @follow = @user.follows.find_by(follow_user_id: current_user.id)
    if @follow
      @follow.destroy
      @follow = nil
    else
      @follow = @user.follows.create!(follow_user_id: current_user.id)
    end
    @follows_count = @user.follows.count

    respond_to do |format|
      format.js
    end
  end

  def block
    @user.blocks.find_or_create_by(block_user_id: current_user.id)

    redirect_to root_path
  end

  def un_block
    if params[:user_id].present? && params[:is_un_block].present? && params[:is_un_block] == "true"
      block = current_user.blockers.where(user_id: params[:user_id].to_i).first
      block.destroy! if block.present?
    end

    respond_to do |format|
      format.js
    end
  end

  def user_blockers
    page = params[:page] ? params[:page].to_i : 1
    user_ids = current_user.blockers.pluck(:user_id)
    @users = User.join_favorites.where(id: user_ids).page(page).per(50)
  end


  def list_user_wait_to_approve_community
    page = params[:page] ? params[:page].to_i : 1

    @favorites = Favorite.includes(:user, :community).joins(:community)
     .where("favorites.user_id != ? AND favorites.status = ? AND communities.community_user_id = ?", current_user.id, Favorite.statuses[:wait_approve], current_user.id)
     .page(page).per(50)
  end

  private

  def get_user
    @user = User.not_blocks(current_user).find_by(id: params[:id].to_i)
    redirect_to root_path if @user.blank?
  end
end
