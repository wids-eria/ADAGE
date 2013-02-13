Ada::Application.routes.draw do
  get "welcome/index"
  get "welcome/my_page"

  devise_for :users
  match "users/authenticate_for_token" => "users#authenticate_for_token", :via => :post
  match "data_collector" => "data#create", :via => :post
  match "data/heatmap" => "data#heatmap"
  match "user/user_data" => "users#get_data" 

  resources :roles
  resources :participant_roles
  resources :games do
    collection do
      get :admin
    end
    member do
      post :search_users 
    end
  end
  resources :schemas
  resources :data do 
    collection do
      get :data_by_version
      get :export
    end
  end
  resources :users do
    collection do
      get :new_sequence
      get :admin
      post :create_sequence
      post :find
    end
    member do
      get :data_by_game
    end
  end

  # OAuth provider:
  get '/auth/ada/authorize' => 'oauth#authorize'
  get '/auth/ada/access_token' => 'oauth#access_token'
  get '/auth/ada/user' => 'oauth#user'
  post '/oauth/token' => 'oauth#access_token'

  root :to => 'welcome#index'
end
