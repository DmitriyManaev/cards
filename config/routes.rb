Rails.application.routes.draw do
  filter :locale
  root to: 'main#index'
  resources :users, only: [:new, :create, :edit, :update, :destroy]
  
  resources :user_sessions, only: :create
  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout

  match 'oauth/callback' => 'oauths#callback', via: [:get, :post]
  get 'oauth/:provider' => 'oauths#oauth', as: :auth_at_provider

  scope module: 'dashboard' do
    resources :cards

    resources :blocks do
      member do
        post 'set_as_current'
        post 'reset_as_current'
      end
    end

    post 'review_card' => 'trainer#review_card'
    get 'trainer' => 'trainer#index'
  end
end
