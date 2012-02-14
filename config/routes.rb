Ada::Application.routes.draw do
  get "welcome/index"
  get "welcome/my_page"

  devise_for :users
  match "users/authenticate_for_token" => "users#authenticate_for_token", :via => :post
  match "data_collector" => "data#create", :via => :post

  resources :data
  resources :users, :only => [] do
    collection do
      get :new_sequence
      post :create_sequence
    end
  end

  root :to => 'welcome#index'
end
