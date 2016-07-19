class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.send_admin_order.subject
  #
  def send_admin_order order_id
    @order = Order.find_by id: order_id
    if @order
      @order_details = @order.line_items.joins(:product)
        .pluck(:product_id, :each_quantity).map do |product_id, each_quantity|
        [Product.find_by(id: product_id), each_quantity]
      end
      @admin = User.find_by role: Settings.role.admin

      mail from: @order.user.email, to: @admin.email, subject: t("mail.ordertitle")
    end
  end
end
