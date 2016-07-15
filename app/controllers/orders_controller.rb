class OrdersController < ApplicationController
  before_action :load_user, :load_session_cart, only: [:new, :create, :show]
  load_and_authorize_resource

  def new
    @order = @user.orders.build
    @product_with_quantity = @session_cart.map {|id, quantity|
      [Product.find_by(id: id), quantity]}
  end

  def create
    @order = @user.orders.build order_params
    if @order.save
      @session_cart.keys.each do |item|
        @line_item = @order.line_items.build
        @line_item.update product_id: item.to_i, each_quantity: @session_cart[item]
        @line_item.save
      end
      @session_cart.clear
      flash[:success] = t "orders.create.saved"
    else
      flash[:danger] = t "orders.create.nosave"
      redirect_to root_url
    end
    redirect_to @user
  end

  def show
    @order = Order.find_by id: params[:id]
    @order_details = LineItem.order_number(@order)
      .pluck(:product_id, :each_quantity).map do |product_id, each_quantity|
      [Product.find_by(id: product_id), each_quantity]
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
