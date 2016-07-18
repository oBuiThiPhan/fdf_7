class SendEmailWorker
  include Sidekiq::Worker

  def perform order_id
    OrderMailer.send_admin_order(order_id).deliver_now
  end
end
