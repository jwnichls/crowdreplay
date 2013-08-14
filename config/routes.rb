Crowdreplay::Application.routes.draw do
  
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
  get 'game_view/graphdata'
  get 'game_view/realtime'
  get 'game_view/tweets_at_time'
  
  # Authentication URLs for Omniauth
  match '/auth/:provider/callback' => 'recorders#auth_redirect'
  
  # Map the root
  root :to => 'recorders#index'
end
