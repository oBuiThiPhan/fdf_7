class Admin::ProductsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @search= Product.ransack params[:q]
    @products= @search.result.order("name").page params[:page]
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = t "controllers.flash.common.create_success",
        objects: t("activerecord.model.product")
      redirect_to admin_products_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update_attributes product_params
      flash[:success] = t "controllers.flash.common.update_success",
        objects: t("activerecord.model.product")
      redirect_to admin_products_url
    else
      render :edit
    end
  end

  def destroy
    session_key = @product.id
    if @product && @product.destroy
      if session[:cart]
        session[:cart].delete(session_key.to_s)
      end
      flash[:success] = t "controllers.flash.common.destroy_success",
        objects: t("activerecord.model.product")
    else
      flash[:danger] = t "controllers.flash.common.destroy_error",
        objects: t("activerecord.model.product")
    end
    redirect_to admin_products_url
  end

  private
  def product_params
    params.require(:product).permit :category_id, :name, :description, :image,
      :price, :race_score, :quantity
  end
end
