class User < ActiveRecord::Base
  enum role: [:guest, :member, :admin]
  TEMP_EMAIL_PREFIX = "change@me"

  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

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
    def find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
      if user
        return user
      else
        registered_user = User.where(:email => access_token.info.email).first
        if registered_user
          return registered_user
        else
          user = User.create(name: data["name"],
            provider:access_token.provider,
            email: data["email"],
            uid: access_token.uid ,
            password: Devise.friendly_token[0,20],
          )
        end
      end
    end

    def from_omniauth_facebook auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email ? auth.info.email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name
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
