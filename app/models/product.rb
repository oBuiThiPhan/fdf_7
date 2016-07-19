class Product < ActiveRecord::Base
  belongs_to :category

  has_many :comments, dependent: :destroy
  has_many :line_items

  mount_uploader :image, ImageUploader

  validates :name, presence: true, length: {maximum: 100}
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :quantity, presence: true, numericality: {greater_than_or_equal_to: 0}
end
