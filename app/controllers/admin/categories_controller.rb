class Admin::CategoriesController < Admin::BaseController
  load_and_authorize_resource find_by: :slug

  def index
    @categories = Category.without_root.order(:level).page params[:page]
    @category_parent = Category.level_parent.order(:left_id)
  end

  def new
    @category = Category.new
  end

  def create
    @parent = Category.find_by id: params[:parent_id].first
    @category = Category.new category_params

    if @category.save
      if @parent
        Category.left_gr_or_eq(@parent.right_id)
          .update_all("left_id = left_id + 2")
        Category.right_gr_or_eq(@parent.right_id)
          .update_all("right_id = right_id + 2")
        @category.update left_id: @parent.right_id, right_id: (@parent.right_id + 1),
          level: (@parent.level + 1)
      else
        @category.left_id = 0
        @category.right_id = 1
      end
      flash[:success] = t "controllers.flash.common.create_success",
        objects: t("activerecord.model.category")
      redirect_to admin_categories_url
    else
      flash[:success] = t "controllers.flash.common.create_error",
        objects: t("activerecord.model.category")
      render :new
    end
  end

  def edit
    @parent = Category.parent_of(@category)
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "controllers.flash.common.update_success",
        objects: t("activerecord.model.category")
      redirect_to admin_categories_url
    else
      render :edit
    end
  end

  def destroy
    number = @category.right_id - @category.left_id + 1

    @category_deleted = Category.where("left_id >= ? and right_id <= ?",
      @category.left_id, @category.right_id)

    if @category.products.blank? && @category_deleted.destroy_all
      Category.left_greater(@category.right_id)
        .update_all("left_id = left_id - '#{number}'")

      Category.right_greater(@category.right_id)
        .update_all("right_id = right_id - '#{number}'")

      flash[:success] = t "controllers.flash.common.destroy_success",
        objects: t("activerecord.model.category")
    else
      flash[:danger] = t "controllers.admin.category.destroy.fail"
    end
    redirect_to admin_categories_url
  end

  private
  def category_params
    params.require(:category).permit :title, :left_id, :right_id, :level
  end
end
