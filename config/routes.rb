Rails.application.routes.draw do
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  resources :positions
  get "dashboard/index"
  get "settings", to: "settings#index", as: :settings
  get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"
  resources :warehouses
  resources :categories
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
  resources :employees do
  collection do
    get :discarded
    get :bulk_payroll
    post :process_bulk_payroll
  end
  member do
      patch :restore
  end
  end

  resources :products do
    member do
      get :new_movement
      post :create_movement
    end
  end
  
  

  
  
end
