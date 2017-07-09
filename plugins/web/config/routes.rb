Rails.application.routes.draw do
  root 'home#index'

  resources :score, only: [:show]

  post 'cart', controller: 'cart', action: :update

  resources :checkout, only: [:create]
end
