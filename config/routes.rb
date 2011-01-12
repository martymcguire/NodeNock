Nodenock::Application.routes.draw do
  resource :phone do
    put 'verify'
  end

  resource :user
  root :to => "users#show"

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
end
