Rails.application.routes.draw do
  root 'feeds#index'

  resources :feeds
end
