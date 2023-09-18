class Admin::CommunitiesController < Admin::BaseController
  before_action :get_community, only: [:destroy, :show, :edit, :update]

  def index
    page = params[:page] ? params[:page].to_i : 1
    q = params[:q] || ''
    q_category = Community::CATEGORY.index(q)
    if q_category.present?
      @communities = Community.search_have_category(q, q_category).order(created_at: :desc).page(page).per(DEFAULT_PER_PAGE)
    else
      @communities = Community.search(q).order(created_at: :desc).page(page).per(DEFAULT_PER_PAGE)
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
    @community = Community.new(community_params)
    if @community.save
      if @community.community_images.present?
        @community.image = @community.community_images.first.image
      else
        @community.image = nil
      end
      @community.save

      redirect_to admin_communities_path, notice: 'success'
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
    if @community.update_attributes(community_params)
      if @community.community_images.present?
        @community.image = @community.community_images.first.image
      else
        @community.image = nil
      end
      @community.save

      flash[:success] = "更新に成功しました。"
      redirect_to admin_communities_path
    else
      render :edit
    end
  end

  def show
    page = params[:page] ? params[:page].to_i : 1
    user_ids = @community.favorites.pluck(:user_id)
    @list_user_joins = User.where(id: user_ids).order(created_at: :desc).page(page).per(DEFAULT_PER_PAGE)
  end

  def destroy
    if @community.destroy
      redirect_to admin_communities_path, notice: '削除成功'
    end
  end

  private

  def community_params
    params[:community][:community_user_id] = create_manager_user.id
    params.require(:community).permit(:name, :description, :category, :community_user_id,community_images_attributes: [:id, :image])
  end

  def get_community
    @community = Community.find(params[:id])
    redirect_to admin_root if @community.blank?
  end

  def create_manager_user
    user = User.find_or_create_by(name: "管理者")
    user.email = "manager_admin@gmail.com"
    user.nickname = "管理者"
    user.name = "管理者"
    user.sex = 0
    user.password = "managerpassword"
    user.confirmed_at = Time.zone.now
    user.save!
    user
  end
end
