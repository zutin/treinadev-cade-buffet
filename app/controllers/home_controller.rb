class HomeController < ApplicationController
  skip_before_action :redirect_customer_from_buffet_management

  def index
    @buffets = Buffet.order(:trading_name)
  end
end