Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  
  # Authentication APIs
  namespace :api do
    namespace :v1 do
      post "login", to: "sessions#create"
      get "me", to: "sessions#show"
      delete "logout", to: "sessions#destroy"
      
      resources :users, only: [:index]
    end
  end 

  # React Application
  root "home#index"

  # Forward frontend routes to the React application
  get "*path", to: "home#index"
end