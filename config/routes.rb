Nodenock::Application.routes.draw do
  resources :calls do
    post "dial_out", :on => :member
  end

  resource :phone do
    match "verify(/:code)" => "phones#verify", :as => :verify
    post "resend_code"
  end

  resource :user
  root :to => "users#show"

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
end
