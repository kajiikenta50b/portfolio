Rails.application.routes.draw do
  root "home#top"

  resources :users, only: %i[new create]
  resources :posts, only: %i[ index new create show ] do
    resources :comments, only: %i[ create edit destroy ], shallow: true
  end

  resource :profile, only: %i[show edit update]

  get 'manual', to: 'manuals#show'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "home#index"
end
