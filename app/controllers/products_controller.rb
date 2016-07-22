class ProductsController < ApplicationController
  load_and_authorize_resource

  def index
    @search= Product.ransack params[:q]
    @products= @search.result.order(quantity: :desc).page params[:page]
    @search.build_sort
  end

  def show
    @product = Product.find_by id: params[:id]
    @comment = Comment.new
    @comments = @product.comments.order created_at: :desc
    unless @product
      flash[:danger] = t "products.show.noproduct"
      redirect_to products_path
    end
  end
end
