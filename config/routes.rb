Rails.application.routes.draw do
  get 'root/index'
  root to: 'root#index'

  resources :memos
  resources :notes
  resources :fields
  resources :farms
  resources :users
end
