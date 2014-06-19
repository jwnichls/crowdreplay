Crowdreplay::Application.routes.draw do

  # Session Routes
  resources :user_sessions

  match 'login' => "user_sessions#new",      :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout

  resources :users, :except => [:index,:show,:destroy,:edit] do
    collection do
      get :edit
    end
  end
  
  # CRUD Resources
  resources :recorders, :except => [:show] do
    member do
      get :start
      get :stop
    end
    
    collection do
      get :auth_redirect
    end
  end
  
  resources :events
  
  # Game View
  get 'game_view/show'
  post 'game_view/show'
  get 'game_view/data'
  get 'game_view/realtime'
  get 'game_view/tweets_at_time'
  
  # Authentication URLs for Omniauth
  match '/auth/:provider/callback' => 'recorders#auth_redirect'
  
  # Map the root
  root :to => 'game_view#index'
end
