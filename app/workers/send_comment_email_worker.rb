class SendCommentEmailWorker
  include Sidekiq::Worker

  def perform comment_id
    CommentMailer.send_orther_mail_when_comment(comment_id).deliver_now
  end
end
