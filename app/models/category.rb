class Category < ActiveRecord::Base
  belongs_to :parent, class_name: Category.name
  has_many :childrens, class_name: Category.name, foreign_key: :parent_id
  has_many :products
  has_many :suggests
end
