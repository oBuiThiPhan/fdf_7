class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    @orders_last_month_ago = Order.last_month_ago_of(@user)
      .order(created_at: :desc).page params[:page]
    @orders_this_month = Order.in_this_month_of(@user)
      .order(created_at: :desc).page params[:page]
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:update_success] = t "user.edit"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
    params.require(:user).permit :name, :email, :password, :password_confirmation,
      :avatar, :phone_number, :address, :chatwork_id
  end
end
