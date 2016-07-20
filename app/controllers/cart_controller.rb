class CartController < ApplicationController
  before_action :load_product, only: [:create, :update]
  before_action :load_session, only: :index

  def index
    @cart = session[:cart] ? session[:cart] : {}
    @product_with_quantity = @cart.map {|id, quantity|
      [Product.find_by(id: id), quantity]}
    each_price = []
    if @product_with_quantity
      @product_with_quantity.each do |product, quantity|
        if product
          each_price << (product.price * quantity.to_i)
        end
      end
    end
    @total = each_price.reduce(0) {|total, price| total + price}
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
      flash[:danger] = t "cart.nomoreproduct", objects: "#{@product.quantity}"
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
    unless @product
      flash[:danger] = t "cart.noproduct"
      session[:cart].delete(params["id"])
      redirect_to root_path
    end
  end

  def load_session
    if session[:cart]
     session[:cart].delete_if {|key, value| Product.find_by(id: key.to_i).nil?}
    end
  end
end
