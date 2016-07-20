class CommentsController < ApplicationController
  include CommentsHelp
  before_action :load_product, only: :create
  load_and_authorize_resource except: :create

  def create
    @comment = @product.comments.build comment_params
    if @comment.rating.blank?
      @comment.rating = 0.0
    end
    if @comment.save
      flash[:success] = t "controllers.flash.common.create_success",
        objects: t("activerecord.model.comment")
    else
      flash[:danger] = t "controllers.flash.common.create_error",
        objects: t("activerecord.model.comment")
    end
    redirect_to product_path(@product)
  end

  def edit
  end

  def update
    if @comment.update_attributes comment_params
      flash[:success] = t "controllers.flash.common.update_success",
        objects: t("activerecord.model.comment")
    else
      flash[:danger] = t "controllers.flash.common.update_error",
        objects: t("activerecord.model.comment")
    end
    redirect_to product_path(@product)
  end

  def destroy
    if @comment.destroy
      flash[:success] = t "controllers.flash.common.destroy_success",
        objects: t("activerecord.model.comment")
    else
      flash[:danger] = t "controllers.flash.common.destroy_error",
        objects: t("activerecord.model.comment")
    end
    redirect_to product_path(@product)
  end

  private
  def comment_params
    params.require(:comment).permit :content, :rating
  end

  def load_product
    @product = Product.find_by id: params[:product_id]
    unless @product
      flash[:danger] = t "products.show.noproduct"
      redirect_to products_path
    end
  end
end
