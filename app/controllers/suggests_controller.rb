class SuggestsController < ApplicationController
  load_and_authorize_resource
  before_action :load_categories, except: [:show, :edit, :update]

  def index
    @suggests = current_user.suggests.where(created_at: Time.zone.now.all_month)
      .page params[:page]
  end

  def new
  end

  def create
    @suggest = current_user.suggests.build suggest_params
    if @suggest.save
      flash[:success] = t "controllers.flash.common.create_success",
        objects: t("activerecord.model.suggest")
      redirect_to suggests_url
    else
      flash[:danger] = t "controllers.flash.common.create_error",
        objects: t("activerecord.model.suggest")
      render :new
    end
  end

  def destroy
    if @suggest.destroy
      flash[:success] = t "controllers.flash.common.destroy_success",
        objects: t("activerecord.model.suggest")
    else
      flash[:danger] = t "controllers.flash.common.destroy_error",
        objects: t("activerecord.model.suggest")
    end
    redirect_to suggests_url
  end

  private
  def suggest_params
    params.require(:suggest).permit :content, :category_id, :picture
  end

  def load_categories
    @categories = Category.parent_category
  end
end
