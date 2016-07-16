class Order < ActiveRecord::Base
  belongs_to :user

  paginates_per 15

  has_many :line_items, dependent: :destroy

  after_save :update_address

  scope :in_this_month, ->{where created_at: 1.month.ago..Time.now}
  scope :in_this_month_of, -> user {where user_id: user.id,
    created_at: Time.now.all_month}
  scope :last_month_ago_of, -> user {where("user_id = ? AND created_at < ?",
    user.id, Time.now.beginning_of_month)}

  private
  def update_address
    unless shipping_address
      shipping_address = user.address
    end
  end
end
