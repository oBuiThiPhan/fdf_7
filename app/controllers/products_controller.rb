class ProductsController < ApplicationController
  def index
    @products = Product.order("price")
      .paginate page: params[:page], per_page: Settings.per_page
  end

  def show
    @product = Product.find_by id: params[:id]
    unless @product
      flash[:danger] = t "products.show.noproduct"
      redirect_to products_path
    end
  end
end
