class ProposalController < ApplicationController
  before_action :redirect_customer_from_managing_orders, only: [:new, :create]
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
      redirect_to order_path(@order), notice: 'Você aprovou o pedido e enviou uma proposta para o usuário.'
    else
      flash.now[:notice] = 'Erro ao salvar proposta'
      render 'new'
    end
  end

  private

  def calculate_price_with_discount_and_taxes(order, discount, tax)
    discount = 0 if discount.nil?
    tax = 0 if tax.nil?

    price = order.calculate_order_price_by_participants()
    ((price + tax) - discount)
  end

  def redirect_customer_from_managing_orders
    redirect_to root_path, notice: 'Você não tem acesso à essa página.' if user_signed_in? && current_user.customer?
  end

  def redirect_from_managing_other_user_orders
    @order = Order.find(params[:order_id])
    redirect_to root_path, notice: 'Você não tem acesso à essa página.' if user_signed_in? && current_user.owner? && @order.buffet.user != current_user
  end
end