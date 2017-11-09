Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :images
  resources :biographies
  resources :authors, only: [:index]
  resources :static_content, only: [:show], path: "/", param: :slug
  root :to => redirect('/home')
end
