Ada::Application.routes.draw do
  get "welcome/index"
  get "profile" => 'welcome#profile'
  get "homepage" => 'dashboards#homepage'

  devise_for :users, :controllers => { registrations: "registrations", sessions: "sessions",:omniauth_callbacks => "users/omniauth_callbacks",:invitations => 'users/invitations' }
  match "users/authenticate_for_token" => "users#authenticate_for_token", :via => :post
  match "data_collector" => "data#create", :via => :post
  match "data/heatmap" => "data#heatmap"
  match "user/user_data" => "users#get_data"

  resources :groups do
    member do
      put :add_user
      delete :remove_user
    end
  end  

  match "explorer" => "data#explorer", :via => :get

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
  resources :implementations
  resources :organizations
  resources :classes do
    member do
      post :import
      post :invite
      get :accept_invite
      post :process_invite
      get :join
      delete "remove_user/:user_id", action: :remove_user, as: :remove_user
    end
  end

  resources :dashboards do
    member do
      post :show
    end
  end
  resources :games do
    member do
      post :search_users
      get :select_graph
      post :value_over_time
      get :statistics
      get :sessions
      get :contexts
      get :developer_tools
      get :logger
      get :researcher_tools
      get :sync_time
      delete :clear_data
    end
  end


  resources :data do
    collection do
      get :find_tenacity_player
      get :data_by_version
      get :export
      get :visualizer_export
      get :session_times
      get :session_logs
      get :context_logs
      get :context_frequency
      get :context_list
      get :context_list_keyed
      get :context_event_type_list
      get :context_event_count
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

  namespace :stats do
    post :save_stat
    post :save_stats
    get :get_stat
    get :get_stats
    delete :clear_stats
  end

  namespace :achievements do
    post :save_achievement
    get :get_achievement
    get :get_achievements
  end

  resources :users do
    collection do
      get :new_sequence
      post :create_sequence
      post :find
      post :generate_guest
      get :admin
      get :guests
      get :reset_password_form
      put :reset_password
      get :teacher_requests
    end

    member do
      get :data_by_game
      get :stats
      get :groups
      get :session_logs
      get :context_logs
      get :get_key_values
      get :get_accessible_games
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
