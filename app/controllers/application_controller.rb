class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception
  include CanCan::ControllerAdditions
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, alert: exception.message
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up do |u|
      u.permit :name, :email, :password, :password_confirmation,
        :remember_me, :role, :chatwork_id
    end
    devise_parameter_sanitizer.permit :account_update do |u|
      u.permit :name, :email, :password, :password_confirmation,
        :current_password, :phone_number, :address, :avatar, :chatwork_id
    end
  end
end
