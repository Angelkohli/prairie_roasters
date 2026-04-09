Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'products#index'

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]
  resources :cart, only: [:index, :create, :update, :destroy]
  resources :orders, only: [:new, :create, :show, :index]
  resources :pages, only: [:show]

  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'
end