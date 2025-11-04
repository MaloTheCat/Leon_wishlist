Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "wishlists#index"

  # Authentication routes
  get    "login",   to: "sessions#new"
  post   "login",   to: "sessions#create"
  delete "logout",  to: "sessions#destroy"
  
  get  "signup", to: "registrations#new"
  post "signup", to: "registrations#create"

  # Family routes
  resource :family, only: [:show] do
    get  :join, on: :collection
    post :join_with_code, on: :collection
  end

  # Wishlists and Gifts routes
  resources :wishlists do
    member do
      post :share
    end
    
    resources :gifts do
      member do
        post :reserve
        delete :unreserve
      end
    end
  end
end
