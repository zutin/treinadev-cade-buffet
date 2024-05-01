class BuffetsController < ApplicationController
  skip_before_action :redirect_user_if_no_buffet, only: [:new, :create]
  skip_before_action :redirect_customer_from_buffet_management, only: [:show, :search]
  before_action :set_buffet, only: [:show, :edit, :update]
  before_action :verify_user_editing, only: [:edit, :update]
  before_action :verify_user_creating, only: [:new, :create]

  def index
    @buffet = current_user.buffet
  end

  def new
    @buffet = Buffet.new
  end

  def create
    b_params = params.require(:buffet).permit(:trading_name, :company_name, :registration_number, :contact_number, :email,
                                              :address, :district, :city, :state, :zipcode, :description, :payment_methods, :buffet_logo)

    @buffet = Buffet.new(b_params)
    @buffet.user = current_user

    if @buffet.save!()
      redirect_to buffets_path, notice: 'Buffet registrado com sucesso.'
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
      redirect_to buffets_path, notice: 'Você editou seu buffet com sucesso.'
    else
      flash.now[:notice] = 'Erro ao editar seu buffet.'
      render 'edit'
    end
  end

  def show; end

  def search
    @search = params['query']
    @buffets = Buffet.where("trading_name LIKE ? OR city LIKE ? OR id IN (SELECT buffet_id FROM events WHERE name LIKE ?)", "%#{@search}%", "%#{@search}%", "%#{@search}%")
  end

  private

  def verify_user_creating
    redirect_to buffets_path, notice: 'Você já tem um buffet registrado.' if current_user.buffet.present?
  end

  def verify_user_editing
    redirect_to buffets_path, notice: 'Você não pode editar o buffet de outro usuário.' if current_user.id != @buffet.user_id
  end

  def set_buffet
    @buffet = Buffet.find(params[:id])
  end
end