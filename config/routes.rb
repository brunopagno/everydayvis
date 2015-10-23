Rails.application.routes.draw do
  root 'pages#index'
  
  get 'C:\Users\Bruno\Workspace\maquinaVirtual\everydayvis\app\views\maps', to: 'maps#iframe'

  resources :people,:maps, only: [:index, :show]


end
