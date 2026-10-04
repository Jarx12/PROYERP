Rails.application.routes.draw do
  get "pages/home"
  get "about",      to: "pages#about",      as: :about
  get "soluciones", to: "pages#soluciones", as: :soluciones
  get "contactanos", to: "pages#contactanos", as: :contactanos
  get "proyectos",  to: "pages#proyectos",  as: :proyectos
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  resources :positions, except: [ :index, :show ]
  resources :users
  get "dashboard", to: "dashboard#index", as: :dashboard_root
  get "settings", to: "settings#index", as: :settings
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"

  resources :warehouses, except: [ :index, :show ]
  resources :categories, except: [ :index, :show ]
  resources :projects, except: [ :index, :show ]
  resources :vehicles
  resources :vehicle_categories, except: [ :index, :show ]
  resources :documents
  resources :transaction_categories, except: [ :index, :show ]
  resources :bank_accounts, except: [ :index, :show ]
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
