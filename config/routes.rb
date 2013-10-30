Ada::Application.routes.draw do
  get "welcome/index"
  get "profile" => 'welcome#profile'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  match "users/authenticate_for_token" => "users#authenticate_for_token", :via => :post
  match "data_collector" => "data#create", :via => :post
  match "data/heatmap" => "data#heatmap"
  match "user/user_data" => "users#get_data" 

  resources :roles
  resources :participant_roles
  resources :games do
    member do
      post :search_users 
      get :select_graph_params
      post :value_over_time
    end
  end
  resources :implementations
  resources :data do
    collection do 
      post :tenacity_player_stats
      get :find_tenacity_player
      get :data_by_version
      get :export
    end
  end

  resources :users do
    collection do
      get :new_sequence
      post :create_sequence
      post :find
      get :admin
      get :reset_password_form
      put :reset_password
    end
    member do
      get :data_by_game
      get :stats
      get :session_logs
    end
  end

  # OAuth provider:
  get '/auth/ada/authorize' => 'oauth#authorize'
  get '/auth/ada/access_token' => 'oauth#access_token'
  get '/auth/ada/user' => 'oauth#user'
  get '/auth/unity_user' => 'oauth#unity_user'
  post '/oauth/token' => 'oauth#access_token'
  get '/auth/failure' => 'oauth#failure'
  get '/auth/authorize_unity' => 'oauth#authorize_unity'
  get '/auth/authorize_unity_fb' => 'oauth#authorize_unity_fb'


  root :to => 'welcome#index'
end
