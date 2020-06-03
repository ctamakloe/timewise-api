Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#authenticate'

  resources :trips
  resources :users
  resources :schedules, only: [:index]
end
