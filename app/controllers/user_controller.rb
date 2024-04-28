class UserController < ApplicationController
  skip_before_action :redirect_customer_from_buffet_management

  def index; end
  def show
    @user = User.find(params[:id])
  end
end