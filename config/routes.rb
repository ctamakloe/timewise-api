Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#authenticate'

  resources :trips do
    resources :ratings, only: [:index]
  end
  resources :users
  resources :schedules, only: [:index] do
    resources :stops, only: [:index]
  end
end
