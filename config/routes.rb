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
  resources :vehicle_categories, except: [:index, :show]
  resources :documents
  resources :transaction_categories
  resources :bank_accounts
  resources :financial_transactions, only: %w[index show new create destroy] do
  collection do
    get :bulk_import
    post :bulk_import
  end
end
  resources :products do
    member do
      get :new_movement
      post :create_movement
    end
  end
  
  

  
  
end
