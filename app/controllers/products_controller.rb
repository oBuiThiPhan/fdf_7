class ProductsController < ApplicationController
  load_and_authorize_resource

  def index
    @search= Product.ransack params[:q]
    @products= @search.result.order(quantity: :desc).page params[:page]
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
