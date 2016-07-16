class Order < ActiveRecord::Base
  belongs_to :user

  paginates_per 15

  has_many :line_items, dependent: :destroy

  after_save :update_address

  scope :in_this_month, ->{where created_at: 1.month.ago..Time.now}

  private
  def update_address
    unless shipping_address
      shipping_address = user.address
    end
  end
end
