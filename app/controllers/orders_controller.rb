class OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :load_user, only: [:new, :create, :show]
  before_action :load_session_cart, only: [:new, :create]

  def new
    @order = @user.orders.build
    @product_with_quantity = @session_cart.map {|id, quantity|
      [Product.find_by(id: id), quantity]}
    each_price = []
    if @product_with_quantity.nil?
      flash[:danger] = "No product for order, please choose some products"
      redirect_to products_path
    else
      @product_with_quantity.each do |product, quantity|
        each_price << (product.price * quantity.to_i)
      end
    end
    @total = each_price.reduce(0) {|total, price| total + price}
  end

  def create
    @order = @user.orders.build order_params
    if current_user.address.blank? && @order.shipping_address.blank?
      flash[:danger] = "Please fill address for shipping"
      redirect_to new_user_order_path(current_user, @order)
    else
      if @order.save
        @session_cart.keys.each do |item|
          quantity = @session_cart[item].to_i
          @line_item = @order.line_items.build
          @each_product = Product.find_by id: item.to_i
          @line_item.update product_id: item.to_i,
            product_name: @each_product.name,
            each_total_price: (@each_product.price * quantity),
            each_quantity: quantity
          @line_item.save
        end
        @session_cart.clear
        flash[:success] = t "orders.create.saved"
        redirect_to user_order_path(@user, @order)
        SendEmailWorker.perform_async @order.id
        SendChatworkWorker.perform_async @order.id
      else
        flash[:danger] = t "orders.create.nosave"
        redirect_to root_url
      end
    end
  end

  def show
    if @order
      @order_details = @order.line_items
    else
      flash[:danger] = t "noorder"
      redirect_to root_url
    end
  end

  private
  def order_params
    params.require(:order).permit :shipping_address
  end

  def load_user
    @user = User.find_by id: params[:user_id]
    unless @user
      redirect_to root_url
    end
  end

  def load_session_cart
    @session_cart = session[:cart]
    if @session_cart.blank?
      redirect_to root_url
    end
  end
end
