class OrdersController < ApplicationController
  skip_before_action :redirect_customer_from_buffet_management
  before_action :redirect_owner_from_ordering, only: [:new, :create]
  before_action :redirect_if_no_event_prices_set, only: [:new, :create]

  def index
    @orders = current_user.orders.order(:created_at) if current_user.customer?
    @orders = current_user.buffet.orders.order(:status) if current_user.owner?
  end

  def show
    @order = Order.find(params[:id])
    current_user.user_opens_chat_messages(@order)
    @chat_messages = retrieve_order_chat_messages(@order)
  end

  def new
    @event = Event.find(params[:event_id])
    @order = Order.new
  end

  def create
    @event = Event.find(params[:event_id])

    order_params = params.require(:order).permit(:desired_address, :desired_date, :estimated_invitees)
    @order = Order.new(order_params)

    @order.desired_address = @event.buffet.address if !@event.can_change_location
    @order.buffet = @event.buffet
    @order.event = @event
    @order.user = current_user
    
    if @order.save!()
      redirect_to orders_path, notice: 'Pedido efetuado com sucesso, o buffet te responderá em breve.'
    else
      flash.now[:notice] = 'Erro ao efetuar pedido'
      render 'new'
    end
  end

  private

  def retrieve_order_chat_messages(order)
    ChatMessage.where(order_id: order).order(:created_at)
  end

  def redirect_owner_from_ordering
    redirect_to root_path, notice: 'Você não tem acesso à essa página.' if user_signed_in? && current_user.owner?
  end

  def redirect_if_no_event_prices_set
    event = Event.find(params[:event_id])
    redirect_to root_path, notice: 'Esse evento não tem preços definidos, portanto não pode ser contratado' if !event.event_price.present?
  end
end