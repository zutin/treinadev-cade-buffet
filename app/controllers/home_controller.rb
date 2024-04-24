class HomeController < ApplicationController
  def index
    @buffets = Buffet.order(:trading_name)
  end
end