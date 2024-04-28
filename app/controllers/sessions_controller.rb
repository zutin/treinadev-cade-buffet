class SessionsController < Devise::SessionsController
  skip_before_action :redirect_user_if_no_buffet, only: [:destroy]
  skip_before_action :redirect_customer_from_buffet_management
end
