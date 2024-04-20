class EventsController < ApplicationController
  def index
    @events = current_user.buffet.events
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    event_params = params.require(:event).permit(:name, :description, :minimum_participants, :maximum_participants,
                                                :default_duration, :menu, :alcoholic_drinks, :decorations,
                                                :valet_service, :can_change_location)
    
    @event = Event.new(event_params)
    @event.buffet = current_user.buffet

    if @event.save!()
      redirect_to event_path(@event), notice: 'Evento cadastrado com sucesso!'
    else
      flash.now[:notice] = 'Erro ao cadastrar evento.'
      render 'new'
    end
  end
end