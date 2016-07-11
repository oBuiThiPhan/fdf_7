Rails.application.routes.draw do
  devise_for :users
  root "static_pages#home"
  get "help" => "static_pages#help"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"

  resources :users, only: [:show, :edit, :update]

  namespace :admin do
    resources :categories, except: [:show]
    resources :products, except: [:show]
  end
end
