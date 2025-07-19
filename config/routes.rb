Rails.application.routes.draw do
  get "demo_sessions/create"
  # Mount the GoodJob dashboard at /good_job
  mount GoodJob::Engine => '/good_job'

  resources :posts

  root 'pages#home'
  get 'pages/home'

  # OmniAuth LinkedIn routes
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  get "/demo_login", to: "demo_sessions#create"

  # Login & logout helpers
  delete '/logout', to: 'sessions#destroy'
end
