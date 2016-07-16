class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  before_save :update_total_price

  scope :order_number, -> order {where order_id: order.id}

  private
  def update_total_price
    each_price = []
    LineItem.order_number(order).each do |line_item|
      product = line_item.product
      new_quantity = product.quantity - line_item.each_quantity
      product.update_attribute :quantity, new_quantity
      each_price << (line_item.each_quantity * product.price)
    end
    total = each_price.reduce(0) {|total, price| total + price}

    order.update_attribute :total_price, total
    now_coin = order.user.coin - total
    order.user.update_attribute :coin, now_coin
  end
end
