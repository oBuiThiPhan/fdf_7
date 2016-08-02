class ProductsController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:category_id]
      @search= Product.select_at_header(params[:category_id].to_i).ransack params[:q]
      @products = @search.result.order(quantity: :desc).page params[:page]
    else
      @search= Product.ransack params[:q]
      @products= @search.result.order(quantity: :desc).page params[:page]
    end
      @search.build_sort
  end

  def show
    @product = Product.find_by id: params[:id]
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
