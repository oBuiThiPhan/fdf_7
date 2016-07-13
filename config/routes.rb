Rails.application.routes.draw do
  devise_for :users
  root "products#index"
  get "/cart" =>"cart#index"
  get "/cart/clear" => "cart#destroy"
  get "/cart/:id" =>"cart#create"
  get "help" => "static_pages#help"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"

  resources :users, only: [:show, :edit, :update]


  resources :products, only: [:index, :show] do
    resources :comments, except: [:index, :show]
  end
  resources :cart, only: [:index]

  namespace :admin do
    resources :categories, except: :show
    resources :users, only: [:index, :destroy]
    resources :products, except: :show
  end
end
