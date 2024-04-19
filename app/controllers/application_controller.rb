class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_user_if_no_buffet

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :full_name, :contact_number])
  end

  def redirect_user_if_no_buffet
    if user_signed_in? && !current_user.buffet.present?
      redirect_to new_buffet_path, notice: 'Você precisa registrar um buffet antes de continuar.'
    end
  end
end
