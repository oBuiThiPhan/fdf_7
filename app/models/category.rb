class Category < ActiveRecord::Base
  has_many :products
  has_many :suggests

  validates :title, presence: true

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history, :finders]

  scope :parent_of, -> child do
    where("left_id < ? and right_id > ?", child.left_id, child.right_id)
      .order(left_id: :desc).first
  end

  scope :have_child, -> parent do
    where("left_id > ? and right_id < ?", parent.left_id, parent.right_id)
  end

  scope :family, -> parent do
    where("left_id >= ? and right_id <= ?", parent.left_id, parent.right_id)
  end

  scope :node_leave, -> {where("(right_id - left_id) = ?", 1)}
  scope :without_root, ->{where.not title: "root"}
  scope :level_parent, ->{where level: 1}
  scope :left_gr_or_eq, -> number {where("left_id >= ?", number)}
  scope :right_gr_or_eq, -> number {where("right_id >= ?", number)}
  scope :left_greater, -> number {where("left_id > ?", number)}
  scope :right_greater, -> number {where("right_id > ?", number)}

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
        result << [separator + category.title, category.left_id, category.id]
      else
        result << [category.title, category.left_id, category.id]
      end
    end
    result.sort {|x, y| x[1] <=> y[1]}
  end

  def should_generate_new_friendly_id?
    new_record? || slug.blank? || title_changed?
  end
end
