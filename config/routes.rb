Rails.application.routes.draw do

  get 'franchises/index'
  get 'franchises/show'
  get 'franchises/new'
  get 'franchises/edit'
  get 'franchises/update'
  get 'franchises/destroy'
  # get 'sources/index'
  # get 'sources/new'
  # get 'sources/show'
  # get 'sources/edit'
  # get 'sources/create'
  # get 'sources/update'
  # get 'sources/destroy'
  # get 'imports/index'
  # get 'imports/new'
  # get 'imports/show'
  # get 'imports/edit'
  # get 'imports/create'
  # get 'imports/update'
  # get 'imports/destroy'
  # get 'contacts/index'
  # get 'contacts/new'
  # get 'contacts/show'
  # get 'contacts/edit'
  # get 'contacts/create'
  # get 'contacts/update'
  # get 'contacts/destroy'
  resources :imports do
    collection do
      post :import
    end
  end
  resources :contacts do
    collection do
      put :fix_header
    end
  end
  # post 'contacts/fix_header'

  resources :sources

	root to: 'users#index'
  	get 'users/index'
  	
  	devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
