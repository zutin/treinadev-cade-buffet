class ProposalController < ApplicationController
  skip_before_action :redirect_customer_from_buffet_management, only: [:accept, :refuse]
  before_action :redirect_from_managing_other_user_orders

  def new
    @proposal = Proposal.new
  end

  def create
    proposal_params = params.require(:proposal).permit(:expire_date, :description, :discount, :tax, :payment_method)

    @proposal = Proposal.new(proposal_params)
    @proposal.order = @order
    @proposal.total_value = calculate_price_with_discount_and_taxes(@order, @proposal.discount, @proposal.tax)

    if @proposal.save!
      @order.accepted_by_owner!
      redirect_to order_path(@order), notice: 'Você aprovou o pedido e enviou uma proposta para o usuário.'
    else
      flash.now[:notice] = 'Erro ao salvar proposta'
      render 'new'
    end
  end

  def accept
    if Date.today < @order.proposal.expire_date
      @order.confirmed!
      redirect_to order_path(@order), notice: 'Você aceitou a proposta com sucesso! Tenha um bom evento!'
    else
      @order.canceled!
      redirect_to order_path(@order), notice: 'O tempo limite para aceitar essa proposta expirou.'
    end
  end

  def refuse
    if @order.status == 'accepted_by_owner' && current_user.customer?
      @order.canceled!
      redirect_to order_path(@order), notice: 'Você recusou a proposta com sucesso!'
    elsif @order.status == 'awaiting_evaluation' && current_user.owner?
      @order.canceled!
      redirect_to order_path(@order), notice: 'Você recusou o pedido com sucesso!'
    else
      redirect_to root_path, notice: 'Ocorreu um erro.'
    end
  end

  private

  def calculate_price_with_discount_and_taxes(order, discount, tax)
    discount = 0 if discount.nil?
    tax = 0 if tax.nil?

    price = order.calculate_order_price_by_participants()
    ((price + tax) - discount)
  end

  def redirect_from_managing_other_user_orders
    @order = Order.find(params[:order_id])
    redirect_to root_path, notice: 'Você não tem acesso à essa página.' if user_signed_in? && current_user.owner? && @order.buffet.user != current_user
    redirect_to root_path, notice: 'Você não tem acesso à essa página.' if user_signed_in? && current_user.customer? && @order.user != current_user
  end
end