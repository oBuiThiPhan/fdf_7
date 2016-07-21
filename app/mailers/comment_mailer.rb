class CommentMailer < ApplicationMailer

  def send_orther_mail_when_comment comment_id
    @comment = Comment.find_by id: comment_id
    if @comment
      @user = @comment.user
      @product = @comment.product
      user_comments = @product.comments.joins(:user)
        .pluck("DISTINCT user_id").reject {|id| id == @user.id}
      @recipients = User.where("id IN (?)", user_comments)

      emails = @recipients.collect(&:email).join(",")

      mail to: emails, subject: "#{@user.name} #{I18n.t("mail.comment")} #{@product.name}"
    end
  end
end
