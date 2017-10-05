Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :biographies, only: [:show, :index]
  resources :static_content, only: [:show], path: "/"
  root :to => redirect('/home')
end
