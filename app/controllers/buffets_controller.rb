class BuffetsController < ApplicationController
  skip_before_action :redirect_user_if_no_buffet, only: [:new, :create]
  before_action :set_buffet, only: [:show, :edit, :update]
  before_action :verify_user, only: [:edit, :update]

  def index; end

  def new
    @buffet = Buffet.new
  end

  def create
    b_params = params.require(:buffet).permit(:trading_name, :company_name, :registration_number, :contact_number, :email,
                                              :address, :district, :city, :state, :zipcode, :description, :payment_methods, :buffet_logo)

    @buffet = Buffet.new(b_params)
    @buffet.user = current_user

    if @buffet.save!()
      redirect_to user_buffets_path(current_user), notice: 'Buffet registrado com sucesso.'
    else
      flash.now[:notice] = 'Erro ao cadastrar buffet.'
      render 'new'
    end
  end

  def edit; end

  def update
    b_params = params.require(:buffet).permit(:trading_name, :company_name, :registration_number, :contact_number, :email,
                                              :address, :district, :city, :state, :zipcode, :description, :payment_methods, :buffet_logo)

    @buffet.user = current_user

    if @buffet.update!(b_params)
      redirect_to user_buffets_path(current_user), notice: 'Você editou seu buffet com sucesso.'
    else
      flash.now[:notice] = 'Erro ao editar seu buffet.'
      render 'edit'
    end
  end

  def show; end

  private

  def verify_user    
    redirect_to user_buffets_path(current_user), notice: 'Você não pode editar o buffet de outro usuário.' if current_user.id != @buffet.user_id
  end

  def set_buffet
    @buffet = Buffet.find(params[:id])
  end
end