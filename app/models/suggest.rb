class Suggest < ActiveRecord::Base
  paginates_per 15

  belongs_to :user
  belongs_to :category

  mount_uploader :picture, PictureUploader

  validates :content, presence: true

  scope :not_accept, ->{where(status: false)}
end
