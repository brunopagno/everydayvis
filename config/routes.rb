Rails.application.routes.draw do
  root 'pages#index'

  resources :people, only: [:index, :show]
  get 'person/:id/:year/:month/:day/:hour', to: 'people#person_hour'
end
