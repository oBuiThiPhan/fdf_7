class CartController < ApplicationController
  before_action :load_product, only: [:create, :update]

  def index
    @cart =session[:cart] ? session[:cart] : {}
    @product_with_quantity = @cart.map {|id, quantity|
      [Product.find_by(id: id), quantity]}
  end

  def create
    id = params[:id]
    unless session[:cart]
      session[:cart] = {}
    end
    cart = session[:cart]
    session_quantity = session[:cart][params["id"]] ? session[:cart][params["id"]] : 0
    if (@product.quantity - session_quantity) <= 0
      flash[:danger] = t "cart.nullproduct"
      redirect_to products_path
    else
      cart[id] = cart[id] ? (cart[id] + 1) : 1
      redirect_to cart_path
    end
  end

  def update
    if @product.quantity < params["quantity"].to_i
      flash[:danger] = t "cart.nomoreproduct"
    else
      session[:cart][params[:id]] = params[:quantity]
    end
    redirect_to cart_path
  end

  def destroy
    session[:cart][params[:id]] = nil
    session[:cart].delete_if {|key, value| value.blank?}
    redirect_to action: :index
  end

  private
  def load_product
    @product = Product.find_by id: params["id"].to_i
  end
end
