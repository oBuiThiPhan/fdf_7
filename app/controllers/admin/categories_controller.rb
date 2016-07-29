class Admin::CategoriesController < ApplicationController
  load_and_authorize_resource

  def index
    @categories = Category.without_root.order(:level).page params[:page]
    @category_parent = Category.level_parent.order(:left)
  end

  def new
    @category = Category.new
  end

  def create
    @parent = Category.find_by id: params[:parent_id]

    @category = Category.new category_params
    if @parent
      Category.left_gr_or_eq(@parent.right).update_all("left = left + 2")
      Category.right_gr_or_eq(@parent.right).update_all("right = right + 2")
      @category.left = @parent.right
      @category.right = @parent.right + 1
      @category.level = @parent.level + 1
    else
      @category.left = 0
      @category.right = 1
    end

    if @category.save
      flash[:success] = t "controllers.flash.common.create_success",
        objects: t("activerecord.model.category")
      redirect_to admin_categories_url
    else
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
    number = @category.right - @category.left + 1

    @category_deleted = Category.where("left >= ? and right <= ?",
      @category.left, @category.right)

    if @category.products.blank? && @category_deleted.destroy_all
      Category.left_greater(@category.right).update_all("left = left - '#{number}'")

      Category.right_greater(@category.right).update_all("right = right - '#{number}'")

      flash[:success] = t "controllers.flash.common.destroy_success",
        objects: t("activerecord.model.category")
    else
      flash[:danger] = t "controllers.admin.category.destroy.fail"
    end
    redirect_to admin_categories_url
  end

  private
  def category_params
    params.require(:category).permit :title, :left, :right
  end
end
