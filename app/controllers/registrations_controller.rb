class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    new_user_buffet_path(current_user) if current_user.owner?
    root_path if current_user.customer?
  end
end