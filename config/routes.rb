Bookmates::Application.routes.draw do
  
  match 'mate/refresh' => 'mates#refresh', :as => :refresh_mate
  resources :mates
  
  match 'auth/sign_in' => 'auth#sign_in', :as => :sign_in
  match 'auth/sign_out' => 'auth#sign_out', :as => :sign_out
  match 'auth/sign_in_callback' => 'auth#sign_in_callback', :as => :sign_in_callback

  root :to => "home#index"
end
