Rails.application.routes.draw do
  root 'pages#index'
  
  #get 'C:\Users\Bruno\Workspace\maquinaVirtual\pagno\app\views\maps', to: 'maps#iframe'

#  get 'C:\Users\Bruno\Workspace\maquinaVirtual\pagno\app\views\login', to: 'login#frame'

#  get 'C:\Users\Bruno\Workspace\maquinaVirtual\pagno\app\views\login\jawbone', to: 'jawbone#frame'

#  get 'C:\Users\Bruno\Workspace\maquinaVirtual\pagno\app\views\jawboneLogged', to: 'jawbonelogged#iframe'

  resources :login,:people,:maps,:jawbone,:jawbonelogged, only: [:index, :show]


end
