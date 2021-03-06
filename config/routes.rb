Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "accounts#new"
  resources :accounts
  resources :sessions, only: [:new, :create, :destroy]
  resources :tokens
  namespace :api, {format: "json"} do
    namespace :v1 do
      get "/timetable", to: "timetable#index"
      namespace :messages do
        get "/list", to: "list#index"
        get "/headlines", to: "headlines#index"
      end
    end
  end
end
