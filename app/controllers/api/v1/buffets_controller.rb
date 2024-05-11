class Api::V1::BuffetsController < ActionController::API
  def index
    search = params[:name]
    buffets = Buffet.where("trading_name LIKE ?", "%#{search}%")
    render status: 200, json: buffets.as_json(except: [:registration_number, :company_name, :created_at, :updated_at]) 
  end

  def show
    begin
      buffet = Buffet.find(params[:id])
      render status: 200, json: buffet.as_json(except: [:registration_number, :company_name, :created_at, :updated_at])
    rescue
      return render status: 404
    end
  end
end