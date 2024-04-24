class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_user_if_no_buffet

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :full_name, :contact_number])
  end

  def redirect_user_if_no_buffet
    redirect_to new_user_buffet_path(current_user), notice: 'Você precisa registrar um buffet antes de continuar.' if user_signed_in? && !current_user.buffet.present?
  end
end
