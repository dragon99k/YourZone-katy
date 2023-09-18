class Communities::CommunityImagesController < ApplicationController
  layout false
  before_action :authenticate_user!

  def show
    @community_image = community.community_images.find(params[:id])
  end

  private

  def community
    @community ||= Community.find(params[:community_id])
  end
end
