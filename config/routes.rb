Ada::Application.routes.draw do
  get "welcome/index"
  get "profile" => 'welcome#profile'

  devise_for :users, :controllers => { registrations: "registrations", :omniauth_callbacks => "users/omniauth_callbacks" }
  match "users/authenticate_for_token" => "users#authenticate_for_token", :via => :post
  match "data_collector" => "data#create", :via => :post
  match "data/heatmap" => "data#heatmap"
  match "user/user_data" => "users#get_data"

  resources :groups do
    member do
      put :add_user
    end
  end

  match "save_game" => "save#save", :via => :post
  match "load_game" => "save#load", :via => :get

  match "save_config" => "config#save", :via => :post
  match "load_config" => "config#load", :via => :get
  match "show_config" => "config#show", :via => :get


  match "game_version_data/save" => 'gv#save', :via => :post
  match "game_version_data/delete" => 'gv#delete', :via => :post
  match "game_version_data" => 'gv#show', :via => :get

  resources :roles
  resources :participant_roles

  resources :games do
    member do
      post :search_users
      get :select_graph
      post :value_over_time
      get :statistics
      get :sessions
      get :contexts
      get :developer_tools
      get :researcher_tools
    end
  end
  resources :implementations
  resources :data do
    collection do
      get :find_tenacity_player
      get :data_by_version
      get :export
      get :session_times
      get :session_logs
      get :context_logs
      get :get_events
      get :key_counts
      get :get_events_by_group
      get :get_game_ids
      get :get_sorted_and_limited_events
      get :field_values
      get :data_selection
      post :data_selection
      get :real_time_selection
      post :real_time_selection
      get :real_time_chart
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
      get :teacher_requests
    end
    member do
      get :data_by_game
      get :stats
      get :session_logs
      get :context_logs
      get :get_key_values
      put :update_teacher_request
    end
  end

  # OAuth provider:
  get '/auth/ada/authorize' => 'oauth#authorize'
  get '/auth/ada/access_token' => 'oauth#access_token'
  get '/auth/ada/user' => 'oauth#user'
  post '/auth/guest' => 'oauth#guest'
  get '/auth/adage_user' => 'oauth#adage_user'
  post '/oauth/token' => 'oauth#access_token'
  get '/auth/failure' => 'oauth#failure'
  post '/auth/authorize_unity' => 'oauth#authorize_unity'
  post '/auth/authorize_unity_fb' => 'oauth#authorize_unity_fb'
  post '/auth/authorize_brainpop' => 'oauth#authorize_brainpop'
  post '/auth/register' => 'oauth#client_side_create_user'

  root :to => 'welcome#index'
end
