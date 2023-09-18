class CommunitiesController < ApplicationController
  before_action :authenticate_user!

  before_action :get_community, only: [:show, :favorite, :edit, :update, :destroy, :un_favorite, :approve_community]
  DEFAULT_PER_PAGE = 50

  def index
    page = params[:page] ? params[:page].to_i : 1

    @communities = Community.all
    @communities = @communities.where(category: params[:category]) if params[:category].present?
    @communities = @communities.where(location: params[:location]) if params[:location].present?
    @communities = @communities.where('MONTH(event_date) = ?', params[:event_month]) if params[:event_month].present?
    @communities = @communities.includes(:approved_favorites).page(page).per(DEFAULT_PER_PAGE)
  
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @community = Community.new()

    image_count = @community.community_images.count

    if image_count < 5
      i = image_count
      while i < 5
        @community.community_images.build
        i += 1
      end
    end
  end

  def create
    ActiveRecord::Base.transaction do
      @community = Community.new(community_params)
      if @community.save
        if @community.community_images.present?
          @community.image = @community.community_images.first.image
        else
          @community.image = nil
        end
        @community.save
        @community.favorites.create!(user_id: current_user.id, status: Favorite.statuses[:approve])

        redirect_to communities_path, notice: 'success'
      else
        image_count = @community.community_images.count

        if image_count < 5
          i = image_count
          while i < 5
            @community.community_images.build
            i += 1
          end
        end
        render :new
      end
    end
  end

  def edit
    image_count = @community.community_images.count

    if image_count < 5
      i = image_count
      while i < 5
        @community.community_images.build
        i += 1
      end
    end
  end

  def update
    @community.assign_attributes(community_params)
    @community.community_images.each do |community_image|
      community_image.set_image
    end
    if @community.save
      if @community.community_images.present?
        @community.image = @community.community_images.first.image
      else
        @community.image = nil
      end
      @community.save

      redirect_to community_path(id: @community.id), notice: 'success'
    else
      render :edit
    end
  end


  def show
    page = params[:page] ? params[:page].to_i : 1
    @user_page = params[:user_page] ? params[:user_page].to_i : 1

    @community = Community.find(params[:id])

    topic = @community.community_topics.includes(:user).order(created_at: :desc)
    @community_topics = topic.page(page).per(10)

    favorite_count = @community.favorites.approve.size

    @user_join_community = @community.favorites.approve.page(@user_page).per(8)

    @all_count = { topic: topic.size, people: favorite_count }

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    if @community.destroy
      redirect_to communities_path, notice: 'success'
    else
      render :edit
    end
  end

  def favorite
    @favorite = @community.favorites.find_by(user_id: current_user.id)
    unless @favorite
      @favorite = @community.favorites.create!(user_id: current_user.id, status: 0)
      @community.notifications.create!(
        user_id: @community.community_user_id,
        notification_type: :another_one_join_event,
        favorite_id: @favorite.id
      )
      # content = "#{current_user.nickname}さんからの参加申請が届きました。"
      # SendNotificationJoinGroup.perform_later(@community.community_user_id, current_user.id, content)
    end

    respond_to do |format|
      format.js
    end
  end

  def list_favorite_community
    page = params[:page] ? params[:page].to_i : 1

    @communities = Community.user_like_communities(current_user.id).page(page).per(DEFAULT_PER_PAGE)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def list_user_favorite
    @community = Community.find_by(id: params[:community_id])

    if current_user.id == @community.community_user_id
      page = params[:page] ? params[:page].to_i : 1

      @users = User.join_favorites
        .where('favorites.community_id = ? AND favorites.user_id != ? AND favorites.status = ?',params[:community_id].to_i, current_user.id, Favorite.statuses[:approve])
        .page(page).per(DEFAULT_PER_PAGE)
    else
      redirect_to community_path(id: @community.id)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def list_user_wait_to_approve
    @community = Community.find_by(id: params[:community_id])

    if current_user.id == @community.community_user_id
      page = params[:page] ? params[:page].to_i : 1

      @users = User.join_favorites
                   .where('favorites.community_id = ? AND favorites.status = ?', params[:community_id].to_i, Favorite.statuses[:wait_approve])
                   .page(page).per(DEFAULT_PER_PAGE)
    else
      redirect_to community_path(id: @community.id)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def un_favorite
    favorite = @community.favorites.find_by(user_id: params[:user_id].to_i)
    if favorite
      favorite.destroy
      @community.notifications.create!(user_id: favorite.user_id, content: 'オーナーが参加申請を拒否しました。', favorite_id: favorite.id)
      @community.approving_notification.update status: :seen
      flash[:success] = '参加申請を拒否しました。'
      # content = "コミュニティの参加申請が拒否されました。"
      # SendNotificationJoinGroup.perform_later(params[:user_id].to_i, current_user.id, content)
      redirect_to community_notifications_path
    end
  end

  def approve_community
    favorite = @community.favorites.find_by(user_id: params[:user_id].to_i)
    if favorite
      favorite.update!(status: Favorite.statuses[:approve])
      @community.notifications.create!(user_id: favorite.user_id, content: 'オーナーが参加申請を承認しました。', favorite_id: favorite.id)
      @community.approving_notification.update status: :seen
      # content = "コミュニティの参加申請が承認されました。"
      # SendNotificationJoinGroup.perform_later(params[:user_id].to_i, current_user.id, content)
      flash[:success] = '参加申請を承認しました。'
      redirect_to community_notifications_path
    end
  end

  private

  def get_community
    @community = Community.find(params[:id])
    redirect_to root_path if @community.blank?
  end

  def community_params
    params.require(:community).permit(:name, :description, :category, :community_user_id, :location, :event_date, :remuneration, community_images_attributes: [:id, :image_topic, :_destroy])
  end

  # def message_join_community community, content, user_favorite_id
  #   chatroom = Chatroom.where("(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)",
  #     user_favorite_id.to_i, community&.community_user_id, community&.community_user_id, user_favorite_id.to_i).first
  #   last_message = chatroom.last_message
  #   is_after = last_message && last_message.user_id == current_user.id
  #   message = chatroom.messages.new(body: content)
  #   message.user = current_user
  #   message.save
  #
  #   user_id = chatroom.user1_id == current_user&.id ? chatroom.user2_id : chatroom.user1_id
  #   MessageRelayJob.perform_later(message, chatroom, is_after, current_user, user_id)
  # end
end
