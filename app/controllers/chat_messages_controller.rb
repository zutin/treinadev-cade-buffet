class ChatMessagesController < ApplicationController
  skip_before_action :redirect_customer_from_buffet_management

  def create
    message_params = params.require(:chat_message).permit(:text)
    @order = Order.find(params[:order_id])

    if current_user != @order.user && current_user != @order.buffet.user
      redirect_to root_path, notice: 'Você não tem acesso à essa página'
    end

    @message = ChatMessage.new(message_params)
    @message.order = @order
    @message.sender = current_user

    if @message.save!
      redirect_to order_path(@order)
    else
      flash.now[:notice] = 'Erro ao enviar mensagem'
      redirect_to order_path(@order)
    end

  end
end