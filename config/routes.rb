Ada::Application.routes.draw do
  get "welcome/index"
  get "welcome/my_page"
  get "data/kodu_vis"

  devise_for :users
  match "users/authenticate_for_token" => "users#authenticate_for_token", :via => :post
  match "data_collector" => "data#create", :via => :post

  resources :data

  match 'game_data' => "data#get_data_by_game"
  match 'user_data' => "users#get_data_by_user"
  match 'user_kodu_activity_data' => "users#get_kodu_activity"
  resources :users, :only => [:index] do
    collection do
      get :new_sequence
      post :create_sequence
    end
  end

  # OAuth provider:
  get '/auth/ada/authorize' => 'oauth#authorize'
  get '/auth/ada/access_token' => 'oauth#access_token'
  get '/auth/ada/user' => 'oauth#user'
  post '/oauth/token' => 'oauth#access_token'

  root :to => 'welcome#index'
end
