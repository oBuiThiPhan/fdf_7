class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    if user_signed_in?
      if current_user.admin?
        redirect_to admin_root_path
      elsif current_user.member?
        redirect_to root_path
      end
    else
      flash[:danger] = t "login.signup"
      redirect_to new_user_registration_path
    end
  end

  def destroy
    super
  end
end
