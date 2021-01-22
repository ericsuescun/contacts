Rails.application.routes.draw do

  resources :franchises do
    collection do
      post :import
    end
  end

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
  
end
