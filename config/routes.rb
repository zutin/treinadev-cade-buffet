Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }
  root to: 'home#index'

  authenticate :user do
    resources :user, only: [:index, :show]
    resources :buffets, path: 'buffet', only: [:index, :new, :create, :edit, :update]
    resources :events, only: [:index, :new, :create] do
      resources :event_prices, path: 'prices', only: [:edit, :update, :new, :create]
      resources :orders, path: 'order', only: [:new, :create]
    end
    resources :orders, only: [:index, :show] do
      resources :chat_messages, path: 'message', only: [:create]
      resources :proposal, only: [:new, :create]
      post 'refuse', to: 'proposal#refuse'
    end
  end

  resources :buffets, path: 'buffet', only: [:show] do
    get 'search', on: :collection
  end
  resources :events, path: 'event', only: [:show]
end
