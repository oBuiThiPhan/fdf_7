class SendChatworkWorker
  include Sidekiq::Worker
  require "chatwork"

  def perform order_id
    @order = Order.find_by id: order_id
    if @order
      ChatWork::Message.create(room_id: Settings.chatroom,
        body: " #{@order.user.email}
        #{I18n.t("chatworks.you_requseted_order_in_app")} #{@order.user.name}")
    end
  end
end
