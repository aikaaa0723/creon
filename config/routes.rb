Rails.application.routes.draw do
  get "hello/index"
  get "tags/index"
  get "tags/show"
  devise_for :users

  root "hello#index" 

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :tweets do
    resources :comments, only: [:create, :destroy, :edit, :update]
    resource :like, only: [:create, :destroy]
  end

  resources :comments, only: [] do
    resource :comment_like, only: [:create, :destroy]
  end

  resources :rooms, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  resources :relationships, only: [:create, :destroy]

  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get :following, :followers
      get :like
    end
  end


  get 'hello/index'
  get "tags", to: "tags#index"
  get "tags/:tag", to: "tags#show", as: :tag
 
  resources :tweets do
    post 'log_view', on: :member
  end
end
