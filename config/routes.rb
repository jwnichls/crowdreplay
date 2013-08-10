Crowdreplay::Application.routes.draw do
  # CRUD Resources
  resources :recorders
  resources :events
  
  # Game View
  get 'game_view/show'
  post 'game_view/show'
  get 'game_view/graphdata'
  get 'game_view/realtime'
  get 'game_view/tweets_at_time'
end
