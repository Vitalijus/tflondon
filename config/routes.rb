Rails.application.routes.draw do
  get 'traffics/index'
  root 'traffics#index'
end
