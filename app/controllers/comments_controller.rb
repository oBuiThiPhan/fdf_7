class CommentsController < ApplicationController
  before_action :load_product, only: [:new, :create]
  load_and_authorize_resource

  def new
  end

  def create
    @comment = @product.comments.build comment_params
    respond_to do |format|
      if @comment.save
        flash[:success] = t "controllers.flash.common.create_success",
          objects: t("activerecord.model.comment")
      else
        flash[:danger] = t "controllers.flash.common.create_error",
          objects: t("activerecord.model.comment")
      end
      format.html {redirect_to @product_path}
      format.js
    end
  end

  private
  def comment_params
    params.require(:comment).permit :user_id, :content, :rating
  end

  def load_product
    @product = Product.find_by id: params[:product_id]
    unless @product
      flash[:danger] = t "products.show.noproduct"
      redirect_to products_path
    end
  end
end
