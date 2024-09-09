# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :users, only: %i[create show update destroy] do
    member do
      get :my_cart, to: 'users#my_cart'
      patch :activate, to: 'users#status_update'
    end
  end
  delete 'users/:id/my_cart/remove_item', to: 'users#remove_item'
  resources :items, only: %i[index show create]
  post 'items/:id/add_item', to: 'users#add_item'
  get 'categories/:id/items', to: 'items#search_with_category'
  post 'login', to: 'session#create'
  delete 'logout', to: 'session#destroy'
  # Defines the root path route ("/")
  # root "posts#index"
end
