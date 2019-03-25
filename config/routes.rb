Rails.application.routes.draw do
  resources :feeds do
    resources :entries
  end

  resources :search, only: '' do
    collection do
      get :entries
    end
  end
end
