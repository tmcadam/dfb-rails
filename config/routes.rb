Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  if Rails.env.development? or Rails.env.test?
      resources :images
      resources :biographies
  else
      resources :biographies, only: [:show]
  end
  resources :static_content, only: [:show], path: "/", param: :slug
  root :to => redirect('/home')
end
