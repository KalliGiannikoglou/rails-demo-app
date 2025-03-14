Rails.application.routes.draw do
  devise_for :users
  get "module3", to: 'home#module3'
  get "module5", to: 'home#module5'

  resources :comments, only: [:create, :destroy, :show]

  get '/sections/new', to: 'sections#new', as: :new_section

  get "/posts", to: "posts#index"
  get "/list", to: "posts#list", as: :list_posts
  post "/posts", to: "posts#create"
  get "/posts/new", to: "posts#new", as: :new_post
  get "/posts/:id/edit", to: "posts#edit", as: :edit_post
  get "/posts/:id", to: "posts#show", as: :post
  patch "/posts/:id", to: "posts#update"
  delete "/posts/:id", to: "posts#destroy"

  get '/payments', to: 'payments#index'
  post '/payments', to: 'payments#create', as: :create_payments

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  root "posts#public"
end
