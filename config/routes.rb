Rails.application.routes.draw do
  devise_for :users
  root to: "products#index"

  resources :products, only: [ :index, :show ]
  resources :carts, only: [ :index ] do
    resources :cart_items, only: [ :create, :destroy ]
  end
end
