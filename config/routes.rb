Rails.application.routes.draw do
  get 'smada/dados'

  root 'pages#index'

  devise_for :users
  
  resources :people, only: [:index, :show]

  get 'person/:id/clock/:year/:month/:day', to: 'people#clock_day', constraints: { format: :json }
  get 'person/:id/histogram/:year/:month/:day', to: 'people#histogram_day', constraints: { format: :json }
  get 'person/:id/histogram/luminosity/:year/:month/:day', to: 'people#luminosity_histogram_day', constraints: { format: :json }
  get 'person/:id/max_activity/:year/:month/:day', to: 'people#max_activity', constraints: { format: :json }
  get 'person/:id/:year/:month/:day/:hour', to: 'people#person_hour', constraints: { format: :json }
  get 'weather/:year/:month/:day/:latitude/:longitude', to: 'weather#show', constraints: { format: :json }
  get 'weather/:year/:month/:day/:latitude/:longitude', to: 'weather#show', constraints: { format: :json }

  get 'smada/dados', to: 'smada#dados'

  get 'dataLogin' => 'login#index'
  get 'uploadFile' => 'import#index'
  #post 'uploadFile/:files' => 'import#index'
  post 'uploadFile', to: 'import#upload' 


  get 'nouser' => 'login#nouser'

  get 'fitbit' => 'fitbit#index'
  get 'jawbone' => 'jawbone#index'
  get 'jawbonecode' => 'jawbone#code'
  get 'jawbonelogged' => 'jawbone#logged'
  get 'fitbitlogged' => 'fitbit#logged'
  get 'fitbittoken' => 'fitbit#token'

  get 'foursquare' => 'foursquare#index'
  get 'foursquarecode' => 'foursquare#code'
  get 'foursquarelogged' => 'foursquare#logged'

  get 'theurl' => 'problemsolver#index'

  resources :login,:people,:maps, only: [:index, :show]
end
