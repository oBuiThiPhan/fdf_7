class Admin::SuggestsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @suggests = Suggest.where(created_at: Time.zone.now.all_month).order("status")
      .page params[:page]
  end

  def update
    respond_to do |format|
      if @suggest
        @suggest.update_attribute :status, true
        flash[:success] = t "controllers.suggests.flash.status",
          objects: @suggest.user.name

      else
        flash[:danger] = t "controllers.flash.common.destroy_error",
          objects: t("activerecord.model.suggest")
      end
      format.html {redirect_to admin_suggests_url}
      format.json {render json: [status: t("views.admin.suggests.index.done"),
        id: params[:id]]}
    end
  end
end
