class ProductsController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
    if params[:category]
      @category = Category.find params[:category]
      @search= Product.select_at_header(@category.id).ransack params[:q]
      @products = @search.result.order(quantity: :desc).page params[:page]
    else
      @search= Product.ransack params[:q]
      @products= @search.result.order(quantity: :desc).page params[:page]
    end
      @search.build_sort
  end

  def show
    if @product
      @comment = @product.comments.build
      if user_signed_in?
        @current_comment = Comment.existed(@product, current_user)
      end
      @comments = @product.comments.order("rating DESC")
        .page params[:page]
    else
      flash[:danger] = t "products.show.noproduct"
      redirect_to products_path
    end
  end
end
