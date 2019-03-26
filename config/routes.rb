Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  resources :feeds do
    resources :entries
  end

  resources :search, only: '' do
    collection do
      get :entries
    end
  end
end
