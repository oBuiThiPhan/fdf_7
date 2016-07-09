class User < ActiveRecord::Base
  enum role: [:admin, :user, :guest]

  mount_uploader :avatar, AvatarUploader
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders, dependent: :destroy
  has_many :suggests, dependent: :destroy
  has_many :comments, dependent: :destroy
end
