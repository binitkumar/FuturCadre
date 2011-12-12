FuturCadre::Application.routes.draw do

	match 'admin' => 'admin/home#login'
	
	namespace :admin do
		resources :categories do
			collection do
				get :sub_categories, :new_sub_category, :edit_sub_category
				post :create_sub_category
				put :update_sub_category
			end
		end
		resources :home do
			collection do
				get :login
				get :dashboard
			end
		end
	end

	devise_for :users, :controllers => {
    :sessions => "users/sessions",
    :confirmation => "users/confirmations",
    :passwords => "users/passwords",
    :registrations => "users/registrations",
    :unlocks => "users/unlocks",
    :omniauth => "users/omniauth_callbacks#create"
  }

	devise_scope :user do
		get "sign_in" => "users/sessions#new"
		get "sign_up" => "users/registrations#new"
		get "sign_out" => "users/sessions#destroy"
  end

	resources :home do
		collection do
			get :change_laguage
			get :get_sub_categories
		end
	end

	resources :search do
		collection do
			post :search
			get :get_sub_categories
      get :get_browse_by
			get :jobs_list
			get :get_regions
			get :get_cities
			get :check_user_name
		end
	end

	resources :jobs do
		collection do
			get :details
		end
	end

	resources :job_seeker do
		collection do
			get :dashboard
		end
	end

	resources :employer do
		collection do
			get :dashboard
		end
	end

  resources :profiles do
    collection do
     get  :new
     post :create_job_seeker
     post :create_employer
     get  :update
     get  :show
     get   :edit
     put  :update_job_seeker
     put :update_employer

    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
