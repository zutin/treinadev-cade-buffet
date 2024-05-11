class Api::V1::EventsController < ActionController::API
  def index
    begin
      buffet = Buffet.find(params[:buffet_id])
      render status: 200, json: buffet.events.as_json(except: [:created_at, :updated_at]) 
    rescue
      return render status: 404
    end
  end

  def show
    begin
      event = Event.find(params[:id])
      date = params[:date]
      guests = params[:guests]

      order = Order.new(desired_date: date, desired_address: event.buffet.address, estimated_invitees: guests, event: event)
      same_date_orders = Order.where(buffet_id: event.buffet, event_id: event.id, desired_date: order.desired_date).where.not(status: 'canceled')

      if same_date_orders.count >= 1
        render status: 200, json: {
          available: false,
          message: 'ERRO - Não disponível'
        }
      else
        price = order.calculate_order_price_by_participants
        render status: 200, json: {
          available: true,
          estimated_value: price
        }
      end
    rescue
      return render status: 404
    end
  end
end