class Admin::OrdersController < Admin::BaseController
  load_and_authorize_resource

  def index
    @orders = Order.in_this_month.order(created_at: :desc).page params[:page]
  end

  def show
    @order = Order.find_by id: params[:id]
    if @order
      @order_details = @order.line_items
    else
      flash[:danger] = t "noorder"
      redirect_to admin_root_url
    end
  end
end
