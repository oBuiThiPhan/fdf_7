class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  after_filter :store_location

  include CanCan::ControllerAdditions
  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back
    else
      redirect_to root_url
    end
  end

  private
  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_stored_location
    session[:return_to] = nil
  end

  def redirect_back_or_to alternate
    redirect_to(session[:return_to] || alternate)
    clear_stored_location
  end

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
