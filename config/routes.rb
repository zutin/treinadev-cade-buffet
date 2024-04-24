Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }
  root to: 'home#index'

  resources :buffets, path: 'buffet', only: [:show]
  resources :events, path: 'event', only: [:show]

  authenticate :user do
    resources :user, only: [:index, :show] do
      resources :buffets, path: 'buffet', only: [:index, :new, :create, :edit, :update]
    end
    resources :events, only: [:index, :new, :create] do
      resources :event_prices, path: 'prices', only: [:edit, :update, :new, :create]
    end
  end
end
