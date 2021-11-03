Rails.application.routes.draw do
  get 'static/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'static#index'

  get 'webhooks/spotify', to: 'webhooks/spotify#create'

  namespace :my do
    resource :profile, only: [:show]
  end
end
