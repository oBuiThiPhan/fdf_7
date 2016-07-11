class User < ActiveRecord::Base
  enum role: [:guest, :member, :admin]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders, dependent: :destroy
  has_many :suggests, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true, length: {maximum: 50}

  mount_uploader :avatar, AvatarUploader

  after_initialize :update_role, if: :new_record?

  def update_role
    self.role = Settings.role.member
  end
end
