class SessionsController < Devise::SessionsController
  skip_before_action :redirect_user_if_no_buffet, only: [:destroy]
end
