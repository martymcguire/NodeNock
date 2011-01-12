Nodenock::Application.routes.draw do
  resource :phone do
    match "verify(/:code)" => "phones#verify", :as => :verify
    post "resend_code"
  end

  resource :user
  root :to => "users#show"

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
end
