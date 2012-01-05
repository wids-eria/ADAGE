Ada::Application.routes.draw do
  get "welcome/index"
  get "welcome/my_page"

  devise_for :users
  match "users/authenticate_for_token" => "users#authenticate_for_token", :via => :post
  match "data_collector" => "data#create", :via => :post

  root :to => 'welcome#index'
end
