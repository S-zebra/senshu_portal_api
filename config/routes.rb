Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "accounts#new"
  resources :accounts
  resources :sessions, only: [:new, :create]
  resources :tokens
end
