Travelquotes::Application.routes.draw do
	devise_for :admin_users, ActiveAdmin::Devise.config
	ActiveAdmin.routes(self)
	root  'static_pages#home'
	resources :products

	resources :quotes do
    member do
      post 'apply_filters'
      post 'remove_filters'
      post 'compare'
      post 'detail'
      post 'email'
    end
  end
	namespace :api, path: '/', constraints: { subdomain: 'api' } do
		resources :policy, except: [:destroy, :update, :edit]
	end

end
