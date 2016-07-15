class Order < ActiveRecord::Base
  belongs_to :user

  has_many :line_items, dependent: :destroy

  after_save :update_address

  private
  def update_address
    unless shipping_address
      shipping_address = user.address
    end
  end
end
