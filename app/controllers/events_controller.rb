class EventsController < ApplicationController
  skip_before_action :redirect_customer_from_buffet_management, only: [:show]

  def index
    @events = current_user.buffet.events
  end

  def show
    @event = Event.find(params[:id])
    redirect_to root_path, notice: 'Esse evento foi desativado pelo dono.' if !@event.is_enabled && user_signed_in? && current_user != @event.buffet.user
  end

  def new
    @event = Event.new
  end

  def create
    event_params = params.require(:event).permit(:name, :description, :minimum_participants, :maximum_participants,
                                                :default_duration, :menu, :alcoholic_drinks, :decorations,
                                                :valet_service, :can_change_location, :event_logo)
    
    @event = Event.new(event_params)
    @event.buffet = current_user.buffet

    if @event.save!()
      redirect_to event_path(@event), notice: 'Evento cadastrado com sucesso!'
    else
      flash.now[:notice] = 'Erro ao cadastrar evento.'
      render 'new'
    end
  end

  def enable
    @event = Event.find(params[:event_id])
    redirect_to events_path, notice: 'Você não pode ativar o evento de outro usuário.' if current_user != @event.buffet.user

    @event.is_enabled = true
    @event.deleted_at = nil
    if @event.save!
      redirect_to events_path, notice: 'Você ativou seu evento com sucesso.'
    else
      flash.now[:notice] = 'Erro ao ativar seu evento.'
      render 'index'
    end
  end

  def disable
    @event = Event.find(params[:event_id])
    redirect_to events_path, notice: 'Você não pode desativar o evento de outro usuário.' if current_user != @event.buffet.user

    @event.is_enabled = false
    @event.deleted_at = DateTime.current
    if @event.save!
      redirect_to events_path, notice: 'Você desativou seu evento com sucesso.'
    else
      flash.now[:notice] = 'Erro ao desativar seu evento.'
      render 'index'
    end
  end
end