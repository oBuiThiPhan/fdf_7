class CartController < ApplicationController
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
    cart[id] = cart[id] ? (cart[id] + 1) : 1
    redirect_to products_path	
  end

  def destroy
    session[:cart] = nil
    redirect_to action: :index
  end
end
