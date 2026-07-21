Rails.application.routes.draw do
  resources :positions
  get "dashboard/index"
  get "settings", to: "settings#index", as: :settings
  get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"
  resources :warehouses
  resources :categories
  resources :employees
  resources :vehicles
  resources :documents
  resources :products do
    member do
      get :new_movement
      post :create_movement
    end
  end
  
  

  
  
end
