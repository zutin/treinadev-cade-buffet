class ReviewsController < ApplicationController
  skip_before_action :redirect_customer_from_buffet_management
  before_action :redirect_users_and_owners, only: [:new, :create]
  before_action :redirect_if_order_not_confirmed, only: [:new, :create]
  before_action :redirect_if_already_reviewed, only: [:new, :create]
  before_action :redirect_if_reviewing_before_event_date, only: [:new, :create]

  def index
    @buffet = Buffet.find(params[:buffet_id])
    @reviews = @buffet.retrieve_reviews
  end

  def new
    @order = Order.find(params[:order_id])

    @review = Review.new
  end

  def create
    @order = Order.find(params[:order_id])

    review_params = params.require(:review).permit(:rating, :comment, :review_photo)
    
    @review = Review.new(review_params)
    @review.order = @order
    @review.reviewer = current_user

    if @review.save()
      redirect_to order_path(@order), notice: 'Pedido avaliado com sucesso!'
    else
      flash.now[:review_errors] = @review.errors.full_messages
      render 'new'
    end
  end

  private

  def redirect_if_reviewing_before_event_date
    order = Order.find(params[:order_id])
    redirect_to root_path, notice: 'Só é possível avaliar pedidos depois da data do evento.' if Date.current < order.desired_date
  end

  def redirect_if_already_reviewed
    order = Order.find(params[:order_id])
    redirect_to order_path(order), notice: 'Já existe uma avaliação para esse pedido' if Review.find_by(order: order)
  end

  def redirect_if_order_not_confirmed
    order = Order.find(params[:order_id])
    redirect_to order_path(order), notice: 'Só podem ser avaliados pedidos confirmados' if !order.confirmed?
  end

  def redirect_users_and_owners
    order = Order.find(params[:order_id])
    redirect_to root_path, notice: 'Você não tem acesso à essa página.' if current_user.owner?
    redirect_to root_path, notice: 'Você não pode avaliar o pedido de outro usuário' if order.user != current_user && current_user.customer?
  end
end