class CommunityTopicsController < ApplicationController
  before_action :authenticate_user!

  before_action :get_community_topic, only: [:show, :edit, :update, :destroy]

  def new
    @community = Community.find_by(id: params[:community_id])
    @community_topic = CommunityTopic.new()

    image_count = @community_topic.community_topic_images.count

    if image_count < 1
      i = image_count
      while i < 1
        @community_topic.community_topic_images.build
        i += 1
      end
    end
  end

  def create
    ActiveRecord::Base.transaction do
      @community = Community.find_by(id: community_topic_params[:community_id])
      @community_topic = CommunityTopic.new(community_topic_params)
      @community_topic.user_id = current_user.id
      if @community_topic.save
        if @community_topic.community_topic_images.present?
          @community_topic.image = @community_topic.community_topic_images.first.image
        else
          @community_topic.image = current_user&.image
        end
        @community_topic.save

        CommunityRoom.create!(creator_id: current_user.id, community_topic_id: @community_topic.id)

        redirect_to community_community_topic_path(id: @community_topic.id, community_id: @community_topic&.community.id), notice: 'success'
      else
        image_count = @community_topic.community_topic_images.count

        if image_count < 1
          i = image_count
          while i < 1
            @community_topic.community_topic_images.build
            i += 1
          end
        end
        render :new
      end
    end
  end

  def edit
    image_count = @community_topic.community_topic_images.count

    if image_count < 1
      i = image_count
      while i < 1
        @community_topic.community_topic_images.build
        i += 1
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @community_topic.assign_attributes(community_topic_params)
      @community_topic.community_topic_images.each do |community_topic_image|
        community_topic_image.set_image
      end
      if @community_topic.save
        if @community_topic.community_topic_images.present?
          @community_topic.image = @community_topic.community_topic_images.first.image
        else
          @community_topic.image = nil
        end
        @community_topic.save

        redirect_to community_community_topic_path(id: @community_topic.id, community_id: @community_topic&.community.id), notice: 'success'
      else
        render :edit
      end
    end
  end

  def show
    last_time = Time.now
    @community_room = @community_topic&.community_room
    @messages = @community_room.community_messages.order_created_at(last_time).reverse

    community = @community_topic&.community

    @user_join_community = community.users.count_user_join_community(current_user)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    if @community_topic.destroy
      redirect_to communities_path(id: params[:community_id]), notice: 'success'
    else
      render :edit
    end
  end

  private

  def get_community_topic
    @community = Community.find_by(id: params[:community_id])
    @community_topic = CommunityTopic.find(params[:id])
    redirect_to communities_path(id: params[:community_id]) if @community_topic.blank?
  end

  def community_topic_params
    params.require(:community_topic).permit(:title, :description, :community_id, :user_id, community_topic_images_attributes: [:id, :image_topic, :_destroy])
  end
end
