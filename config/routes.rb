Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :jobs, only: [:index]

  root "jobs#index"

  get "app_inspector", to: "app_inspector#index"
end
