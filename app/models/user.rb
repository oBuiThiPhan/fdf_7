class User < ActiveRecord::Base
  enum role: [:guest, :member, :admin]

  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, omniauth_providers: [:facebook]

  has_many :orders, dependent: :destroy
  has_many :suggests, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true, length: {maximum: 50}

  mount_uploader :avatar, AvatarUploader

  after_initialize :update_role, if: :new_record?

  def update_role
    self.role = Settings.role.member
  end

  class << self
    def from_omniauth auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name   # assuming the user model has a name
      end
    end

    def new_with_session params, session
      super.tap do |user|
        if data = session["devise.facebook_data"] &&
          session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end
  end
end
