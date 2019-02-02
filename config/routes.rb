Rails.application.routes.draw do
  devise_for :users
  root to: "identifiers#index"
  get '/identifier/:id', to: 'identifiers#show', as: 'identifier'
  resource :identifiers

end
