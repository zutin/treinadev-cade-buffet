class Api::V1::BuffetsController < ActionController::API
  def index
    search = params[:name]
    buffets = Buffet.where("is_enabled = ? AND (trading_name LIKE ?)", true, "%#{search}%")
    render status: 200, json: buffets.as_json(except: [:registration_number, :company_name, :created_at, :updated_at, :is_enabled ,:deleted_at, :user_id], methods: [:average_rating]) 
  end

  def show
    begin
      buffet = Buffet.find_by!(id: params[:id], is_enabled: true)
      render status: 200, json: buffet.as_json(except: [:registration_number, :company_name, :created_at, :updated_at, :is_enabled ,:deleted_at, :user_id], methods: [:average_rating])
    rescue
      return render status: 404
    end
  end
end