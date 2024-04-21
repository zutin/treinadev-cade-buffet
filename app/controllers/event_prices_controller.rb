class EventPricesController < ApplicationController
  def new
    @event = Event.find(params[:event_id])
    redirect_to events_path, notice: 'Você não pode editar eventos de outro usuário' if @event.buffet != current_user.buffet

    @event_price = EventPrice.new
  end

  def create
    @event = Event.find(params[:event_id])
    redirect_to events_path, notice: 'Você não pode editar eventos de outro usuário' if @event.buffet != current_user.buffet

    prices_params = params.require(:event_price).permit(:base_price, :additional_person_price, :additional_hour_price,
                                                        :weekend_base_price, :weekend_additional_person_price, :weekend_additional_hour_price)

    @event_price = EventPrice.new(prices_params)
    @event_price.event = @event

    if @event_price.save!
      redirect_to events_path, notice: 'Preços foram salvos com sucesso!'
    else
      flash.now[:notice] = 'Erro ao salvar preços.'
      render 'new'
    end
  end
end