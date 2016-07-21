class Admin::CategoriesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @categories = Category.without_root.order(:level).page params[:page]
    @category_parent = Category.level_parent.order(:left_index)
  end

  def new
    @category = Category.new
  end

  def create
    @parent = Category.find_by id: params[:parent_id]

    @category = Category.new category_params
    if @parent
      Category.left_gr_or_eq(@parent.right_index)
        .update_all("left_index = left_index + 2")
      Category.right_gr_or_eq(@parent.right_index)
        .update_all("right_index = right_index + 2")
      @category.left_index = @parent.right_index
      @category.right_index = @parent.right_index + 1
      @category.level = @parent.level + 1
    else
      @category.left_index = 0
      @category.right_index = 1
    end

    if @category.save
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
    @category = Category.find_by id: params[:id]
    number = @category.right_index - @category.left_index + 1

    @category_deleted = Category.where("left_index >= ? and right_index <= ?",
      @category.left_index, @category.right_index)

    if @category.products.blank? && @category_deleted.destroy_all
      Category.left_greater(@category.right_index)
        .update_all("left_index = left_index - '#{number}'")

      Category.right_greater(@category.right_index)
        .update_all("right_index = right_index - '#{number}'")

      flash[:success] = t "controllers.flash.common.destroy_success",
        objects: t("activerecord.model.category")
    else
      flash[:danger] = t "controllers.admin.category.destroy.fail"
    end
    redirect_to admin_categories_url
  end

  private
  def category_params
    params.require(:category).permit :title, :left_index, :right_index, :level
  end
end
