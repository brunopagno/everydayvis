Rails.application.routes.draw do
  root 'pages#index'

  devise_for :users
  
  resources :people, only: [:index, :show]

  get 'person/:id/clock/:year/:month/:day', to: 'people#clock_day', constraints: { format: :json }
  get 'person/:id/histogram/:year/:month/:day', to: 'people#histogram_day', constraints: { format: :json }
  get 'person/:id/max_activity/:year/:month/:day', to: 'people#max_activity', constraints: { format: :json }
  get 'person/:id/:year/:month/:day/:hour', to: 'people#person_hour', constraints: { format: :json }
  get 'weather/:year/:month/:day/:latitude/:longitude', to: 'weather#show', constraints: { format: :json }
  get 'weather/:year/:month/:day/:latitude/:longitude', to: 'weather#show', constraints: { format: :json }

  get 'fitbitLogin' => 'login#index'

  resources :login,:people,:maps,:jawbone,:jawbonelogged, only: [:index, :show]
end
