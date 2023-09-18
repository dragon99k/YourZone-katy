class ListFavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    page = params[:page] ? params[:page].to_i : 1

    @users = User.user_likes_me(current_user).not_blocks(current_user).page(page).per(50)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def list_user_favorites
    page = params[:page] ? params[:page].to_i : 1

    @users = User.my_user_likes(current_user).not_blocks(current_user).page(page).per(50)

    respond_to do |format|
      format.html
      format.js
    end
  end
end
