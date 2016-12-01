Rails.application.routes.draw do
  resources :traffics, only: [:index]
  root 'traffics#index'
end
