Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
      patch 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :images
  get 'biographies/reset_featured' => "biographies#reset_featured"
  get 'biographies/check_links' => "biographies#check_links"
  resources :biographies
  resources :authors, except: [:show]
  get 'comments/approve/(:approve_key)' => "comments#approve", :as => 'approve_comment'
  resources :comments
  resources :static_content, except: [:index], path: "/", param: :slug
  root :to => redirect('/home')
end
