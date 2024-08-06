Rails.application.routes.draw do
  resources :recipes, only: %i[show index]
  resources :ingredients, only: %i[create destroy]
  devise_for :users

  root "static_pages#home"
end
