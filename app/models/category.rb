class Category < ActiveRecord::Base
  has_many :products
  has_many :suggests

  validates :title, presence: true

  scope :parent_of, -> child do
    where("left_index < ? and right_index > ?", child.left_index, child.right_index)
      .order(left_index: :desc).first
  end

  scope :have_child, -> parent do
    where("left_index > ? and right_index < ?", parent.left_index, parent.right_index)
  end

  scope :family, -> parent do
    where("left_index >= ? and right_index <= ?", parent.left_index, parent.right_index)
  end

  scope :node_leave, -> {where("(right_index - left_index) = ?", 1)}
  scope :without_root, ->{where.not title: "root"}
  scope :level_parent, ->{where level: 1}
  scope :left_gr_or_eq, -> number {where("left_index >= ?", number)}
  scope :right_gr_or_eq, -> number {where("right_index >= ?", number)}
  scope :left_greater, -> number {where("left_index > ?", number)}
  scope :right_greater, -> number {where("right_index > ?", number)}

  private
  def self.for_select
    Category.without_root.uniq.reject{|c| Category.node_leave.include?(c)}.map do |category|
      [category.title, Category.have_child(category).map {|c| [c.title, c.id]}]
    end
  end

  def self.nested_option result = nil
    result ||= []
    node_or_leaf ||= Category.without_root.uniq
    node_or_leaf.each do |category|
      if Category.node_leave.include?(category)
        separator = ""
        category.level.times { separator = separator + '-' }
        result << [separator + category.title, category.left_index, category.id]
      else
        result << [category.title, category.left_index, category.id]
      end
    end
    result.sort {|x, y| x[1] <=> y[1]}
  end
end
