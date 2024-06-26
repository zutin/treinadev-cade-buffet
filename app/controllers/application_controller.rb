class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_user_if_no_buffet
  before_action :redirect_customer_from_buffet_management

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :full_name, :contact_number, :social_security_number, :role, :profile_picture])
  end

  def redirect_user_if_no_buffet
    redirect_to new_buffet_path, notice: 'Você precisa registrar um buffet antes de continuar.' if user_signed_in? && !current_user.buffet.present? && current_user.owner?
  end

  def redirect_customer_from_buffet_management
    redirect_to root_path, notice: 'Você não tem acesso à essa página.' if user_signed_in? && current_user.customer?
  end
end
