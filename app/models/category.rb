class Category < ActiveRecord::Base
  belongs_to :parent, class_name: Category.name, foreign_key: :parent_id
  has_many :children, class_name: Category.name, foreign_key: :parent_id,
    dependent: :destroy
  has_many :products
  has_many :suggests

  validates :title, presence: true

  scope :parent_category, ->{where parent_id: nil}
  scope :children, ->{where.not parent_id: nil}
end
