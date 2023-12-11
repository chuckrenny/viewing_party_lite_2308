Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "welcome#index"

  get "/register", to: "users#new"
  get "/login", to: "users#login_form"
  post "/login", to: "users#login"

  resources :users, only: [:create, :show] do
    resources :movies, only: [:index, :show] do
      resources :viewing_parties, only: [:new, :create]
    end
    member do
      get "discover", to: "movies#discover"
    end
  end
end
