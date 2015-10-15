Rails.application.routes.draw do
  root 'pages#index'

  resources :people, only: [:index, :show]

end
