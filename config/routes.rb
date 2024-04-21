Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }
  root to: 'home#index'

  authenticate :user do
    resources :user, only: [:index, :show]
    resources :buffets, only: [:index, :show, :new, :create, :edit, :update]
    resources :events, only: [:index, :show, :new, :create] do
      resources :event_prices, path: 'prices', only: [:edit, :update, :new, :create], shallow: true
    end
  end
end
