Rails.application.routes.draw do
  root 'pages#index'

  resources :people, only: [:index, :show]


  get 'person/:id/:year/:month/:day/:hour', to: 'people#person_hour', constraints: { format: :json }
  get 'weather/:year/:month/:day/:latitude/:longitude', to: 'weather#show', constraints: { format: :json }

  resources :login,:people,:maps,:jawbone,:jawbonelogged, only: [:index, :show]
end
