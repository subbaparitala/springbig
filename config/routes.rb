Rails.application.routes.draw do
  devise_for :users
  root to: "identifiers#index"

  resource :identifiers

end
