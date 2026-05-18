Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"

  get 'main/index'
  get 'main/help'
  get 'main/contacts'
  get 'main/about'


  match 'work',          to: 'work#index',         via: 'get'
  match 'choose_theme',  to: 'work#choose_theme',  via: :get
  match 'display_theme', to: 'work#display_theme', via: :post

  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show, :index]
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  namespace :api do
    get 'next_image', to: 'api#next_image'
    get 'prev_image', to: 'api#prev_image'
    get 'save_value', to: 'api#save_value'
  end

  root 'work#index'
end