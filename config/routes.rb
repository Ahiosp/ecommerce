Rails.application.routes.draw do
  post "/webhooks/stripe", to: "stripe_webhooks#create"

  devise_for :users

  root to: "products#index"

  resources :products, only: [ :index, :show ]

  resources :carts, only: [ :index ] do
    resources :cart_items, only: [ :create, :destroy ]
  end

  resources :orders, only: [ :new, :create, :show ]

  resources :payments, only: [ :create, :new ]

end
