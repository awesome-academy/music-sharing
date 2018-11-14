Rails.application.routes.draw do
  root "static_pages#index"
  get "my_songs", to: "users#my_song"
  get "my_albums", to: "users#my_album"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "signup", to: "users#new"
  post "signup", to: "users#create"
  resources :users, except: :destroy
  resources :password_resets, except: %i(index show destroy)
  resources :account_activations, only: :edit
  resources :albums
  resources :songs do
    resources :lyrics
  end
  namespace :admin do
    get "/", to: "dashboards#index"
    resources :categories
    resources :singers
    resources :authors
    resources :users, except: %i(new create)
    resources :lyrics, except: %i(new create)
  end
end
