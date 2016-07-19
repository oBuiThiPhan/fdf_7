class SendChatworkWorker
  include Sidekiq::Worker
  require "chatwork"

  def perform order_id
    @order = Order.find_by id: order_id
    ChatWork::Message.create(room_id: @order.user.chatwork_id,
      body: "#{I18n.t("chatworks.you_requseted_order_in_app")}")
    ChatWork::Message.create(room_id: Settings.chatroom,
      body: " #{@order.user.email}
      #{I18n.t("chatworks.you_requseted_order_in_app")}")
  end
end
