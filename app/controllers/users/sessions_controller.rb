class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    if current_user.admin?
      redirect_to admin_root_path
    else
      redirect_to root_path
    end
  end
end
