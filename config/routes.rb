Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: "users/sessions",
    omniauth_callbacks: "omniauth_callbacks"}
  root "products#index"
  get "/cart" =>"cart#index"
  delete "/cart/:id/delete" => "cart#destroy"
  post "/cart/:id" =>"cart#create"
  get "/cart/:id/edit" => "cart#edit"
  patch "/cart/:id" =>"cart#update"
  get "help" => "static_pages#help"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"
  post "/cart/:id" => "cart#update"
  resources :users, only: [:show, :edit, :update] do
    resources :orders, only: [:new, :create, :show]
  end

  resources :suggests, except: [:show, :edit, :update]

  resources :products, only: [:index, :show] do
    resources :comments, except: [:index, :show]
  end

  resources :cart

  namespace :admin do
    root "products#index"
    resources :categories, except: :show
    resources :users, only: [:index, :destroy]
    resources :products, except: :show
    resources :suggests
    resources :orders, only: [:index, :show]
  end
end
