Nodenock::Application.routes.draw do
  resources :users
  root :to => "users#show"

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
end
