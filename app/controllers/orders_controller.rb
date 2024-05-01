class OrdersController < ApplicationController
  skip_before_action :redirect_customer_from_buffet_management

  def index
    @orders = current_user.orders if current_user.customer?
    @orders = current_user.buffet.orders if current_user.owner?
  end

  def show
    @order = Order.find(params[:id])
  end
end