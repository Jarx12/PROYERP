Rails.application.routes.draw do
  get "dashboard/index"
  resources :employees
  resources :vehicles
  resources :documents
  resources :products do
    member do
      get :new_movement
      post :create_movement
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check

  
  root "dashboard#index"
end
