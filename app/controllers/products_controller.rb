class ProductsController < ApplicationController
  def index
    @search= Product.ransack params[:q]
    @products= @search.result.paginate page: params[:page],
      per_page: Settings.per_page
    @search.build_sort
  end

  def show
    @product = Product.find_by id: params[:id]
    @comments = @product.comments.order("rating DESC")
      .paginate page: params[:page], per_page: Settings.per_page
    unless @product
      flash[:danger] = t "products.show.noproduct"
      redirect_to products_path
    end
  end
end
