Rails.application.routes.draw do
  resources :feeds do
    resources :entries
  end
end
