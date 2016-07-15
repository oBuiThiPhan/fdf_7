class Admin::OrdersController < ApplicationController
  load_and_authorize_resource

  def index
    @orders = Order.in_this_month.order(created_at: :desc).page params[:page]
  end

  def show
    @order = Order.find_by id: params[:id]
    @order_details = LineItem.order_number(@order)
      .pluck(:product_id, :each_quantity).map do |product_id, each_quantity|
      [Product.find_by(id: product_id), each_quantity]
    end
  end
end
