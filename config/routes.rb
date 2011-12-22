Ada::Application.routes.draw do
  get "welcome/index"

  devise_for :users
  match "/users/authenticate_for_token" => "users#authenticate_for_token"

  root :to => 'welcome#index'
end
