class UserRequired
  def self.matches?(request)
    User.find_by_id(request.session[:user_id]).present?
  end
end
Rails.application.routes.draw do
  resources :pastes
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create,:destroy]
  get '/signup', to: 'users#new', as: :signup
  get '/login', to: 'sessions#new', as: :login
  get '/logout', to: 'sessions#destroy', as: :logout
  root :to => 'pastes#index', constraints: UserRequired
  root :to => 'home#index'
end
