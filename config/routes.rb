Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }
  root to: 'home#index'

  authenticate :user do
    resources :user, only: [:index, :show]
    resources :buffets, only: [:index, :show, :new, :create]
  end
end
