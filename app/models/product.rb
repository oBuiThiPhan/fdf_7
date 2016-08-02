class Product < ActiveRecord::Base
  belongs_to :category

  has_many :comments, dependent: :destroy
  has_many :line_items

  mount_uploader :image, ImageUploader

  validates :name, presence: true, length: {maximum: 100}
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :quantity, presence: true, numericality: {greater_than_or_equal_to: 0}

  scope :select_at_header, -> category_id {where category_id: category_id}

  scope :by_category_id, -> category_id do
    where("category_id IN (?)",
      Category.family(Category.find_by(id: category_id)).uniq.map(&:id))
  end

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  private
  def self.ransackable_scopes auth_object = nil
    [:by_category_id]
  end

  def should_generate_new_friendly_id?
    new_record? || slug.blank?
  end
end
