class CommentsController < ApplicationController
  include CommentsHelp
  before_action :load_product, only: :create
  load_and_authorize_resource except: :create
 
  def create
    @comment = @product.comments.build comment_params
    @comment.user = current_user
    @comment.rating = 0 if @comment.rating.blank?
    if @comment.save
      data = json_data @comment
      data[:count_comments] = @product.comments.count
      respond_to do |format|
        format.json {render json: data}
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html {head :ok}
    end
  end

  private
  def comment_params
    params.require(:comment).permit :content, :rating
  end

  def load_product
    @product = Product.find_by id: params[:product_id]
    unless @product
      flash[:danger] = t "products.show.noproduct"
      redirect_to products_path
    end
  end
end
