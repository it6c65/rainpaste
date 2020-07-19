Rails.application.routes.draw do
  resources :pastes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "pastes#index"
end
