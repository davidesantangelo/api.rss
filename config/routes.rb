Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  root 'welcome#index'

  resources :feeds, only: [:index, :show, :create] do
    resources :entries, only: [:index, :show]
    resources :logs, only: [:index, :show]
  end

  resources :search, only: '' do
    collection do
      get :entries
    end
  end

  resources :tokens, only: [:create] do
    collection do
      get :current
      post :refresh
    end
  end

  
end
