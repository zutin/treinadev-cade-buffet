class EventPricesController < ApplicationController
  before_action :verify_user_editing

  def new
    @event = Event.find(params[:event_id])
    @event_price = EventPrice.new
  end

  def create
    @event = Event.find(params[:event_id])

    prices_params = params.require(:event_price).permit(:base_price, :additional_person_price, :additional_hour_price,
                                                        :weekend_base_price, :weekend_additional_person_price, :weekend_additional_hour_price)

    @event_price = EventPrice.new(prices_params)
    @event_price.event = @event

    if @event_price.save
      redirect_to events_path, notice: 'Preços foram salvos com sucesso!'
    else
      flash.now[:event_price_errors] = @event_price.errors.full_messages
      render 'new'
    end
  end

  private

  def verify_user_editing
    event = Event.find(params[:event_id])
    redirect_to events_path, notice: 'Você não pode editar eventos de outro usuário' if event.buffet != current_user.buffet
  end
end