Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :images
  get 'biographies/reset_featured' => "biographies#reset_featured"
  resources :biographies
  resources :authors, only: [:index]
  resources :static_content, only: [:show], path: "/", param: :slug
  root :to => redirect('/home')
end
