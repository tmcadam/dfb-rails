Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :biographies, only: [:show, :index, :new]
  if Rails.env.development? or Rails.env.test?
      resources :images
  end
  resources :static_content, only: [:show], path: "/", param: :slug
  root :to => redirect('/home')
end
