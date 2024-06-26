Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions", passwords: "passwords" }
  root to: 'home#index'

  authenticate :user do
    resources :user, only: [:index, :show]
    resources :buffets, path: 'buffet', only: [:index, :new, :create, :edit, :update] do
      post 'enable', to: 'buffets#enable'
      post 'disable', to: 'buffets#disable'
    end
    resources :events, only: [:index, :new, :create] do
      resources :event_prices, path: 'prices', only: [:edit, :update, :new, :create]
      resources :orders, path: 'order', only: [:new, :create]
      post 'enable', to: 'events#enable'
      post 'disable', to: 'events#disable'
    end
    resources :orders, only: [:index, :show] do
      resources :chat_messages, path: 'message', only: [:create]
      resources :proposal, only: [:new, :create]
      resources :reviews, only: [:new, :create]
      post 'refuse', to: 'proposal#refuse'
      post 'accept', to: 'proposal#accept'
    end
  end

  resources :buffets, path: 'buffet', only: [:show] do
    resources :reviews, only: [:index]
    get 'search', on: :collection
  end
  resources :events, path: 'event', only: [:show]

  namespace :api do
    namespace :v1 do
      resources :buffets, only: [:index, :show] do
        resources :events, only: [:index]
      end
      resources :events, only: [:show]
    end
  end
end
