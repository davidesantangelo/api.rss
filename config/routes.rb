# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'welcome#index'

  resources :feeds, only: %i[index show create] do
    collection do
      get :popular
    end
    resources :entries, only: %i[index show] do
      member do
        get :tags
      end
    end
    resources :logs, only: %i[index show]
    resources :webhooks
  end

  resources :search, only: '' do
    collection do
      get :entries
      get :feeds
    end
  end

  resources :tokens, only: [:create] do
    collection do
      get :current
      post :refresh
    end
  end

  resources :stats, only: [:index]
end
