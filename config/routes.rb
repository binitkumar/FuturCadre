FuturCadre::Application.routes.draw do

  match 'admin' => 'admin/home#login'

  #match 'sannan' => 'application#check_url'
  # match 'translate' => 'translate#index', :as => :translate_list
  #match 'translate/translate' => 'translate#translate', :as => :translate
  #match 'translate/reload' => 'translate#reload', :as => :translate_reload

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
    match 'translate' => 'translate#index', :as => :translate_list
    match 'translate/translate' => 'translate#translate', :as => :translate
    match 'translate/reload' => 'translate#reload', :as => :translate_reload
    resources :groups do
      collection do
        get :index
        get :index_school
        get :index_job
        get :new
        post :create
        get :edit
        get :new_job_group, :job_groups
        post :create_job_group
        post :create_group_school
        get :destroy
        get :edit_job_group
        get :remove_job
        put :update
        put :update_school_group
        get :new_manager
        get :set_manager
      end
    end

    resources :news do
      collection do
        get :approve_news

      end
    end

    resources :packages do
      collection do
        get :user_package
        get :set_package
      end
    end

    resources :users do
      collection do
        get :get_users
        get :set_package
        post :change_package
      end
    end

    resources :package_users do
      collection do

      end
    end

  end


  devise_for :users, :controllers => {
      :sessions      => "users/sessions",
      :confirmation  => "users/confirmations",
      :passwords     => "users/passwords",
      :registrations => "users/registrations",
      :unlocks       => "users/unlocks",
      :omniauth      => "users/omniauth_callbacks#create"
  }

  devise_scope :user do
    get "sign_in" => "users/sessions#new"
    get "sign_up" => "users/registrations#new"
    get "sign_out" => "users/sessions#destroy"
    get "password_recovery" => "users/passwords#new"
    get "new_user" => "users/registrations#new_user"
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
      get :get_jobs_by_company
      get :categories_jobs_list
      get :get_jobs_by_region
      get :profile_search
      get :sort_result
      get :sort_result_asc
      get :sorting_box
      get :advance_job_search
      get :advance_search

    end
  end

  resources :jobs do
    collection do
      get :details
      get :new
      post :create_job
      get :edit
      put :update
      get :remove_language
      get :show
      get :job_employer
      get :new_application
      post :apply_job
      get :remove_education
      get :sort_result
    end
  end

  resources :job_seeker do
    collection do
      get :dashboard
      get :resume_index
      get :event
      get :new_event
      post :create_event
      get :job_seeker_jobs
      post :new_resume
      get :my_theses
      get :event_mailer
      get :delete_cv
      get :make_cv_publishable
      get :add_cv
    end
  end

  resources :employer do
    collection do
      get :dashboard
      get :employer_jobs
      get :employer_statistics
      get :event
      get :new_event
      post :create_event
      get :delete_job
      get :my_job_detail
      get :contact_information
      post :contact_job_seeker
      get :download
      get :my_theses
      get :search_job_seeker
      get :view_cv
      get :select_profile
      get :event_mailer
      get :employer_packages
      get :employer_billing_information
      post :checkout
      get :transaction_success_show
      get :decline_applicant, :add_search_result, :get_my_orders
    end
  end


  resources :profiles do
    collection do
      get :new
      post :create_job_seeker_basic_information, :create_job_seeker_education_details, :create_job_seeker_education_details_next, :create_job_seeker_professional_experience, :create_job_seeker_professional_experience_next, :create_job_seeker_additional_information
      post :create_employer, :upload_photo, :upload_company_photo, :upload_cover_letter
      post :create_employer_basic_information, :create_employer_company_details
      get :update, :remove_edu_info, :remove_prof_info
      put :update_job_seeker
      put :update_employer
      post :create_institute
      get :show_profile, :show_account, :skip_action, :move_to_action
    end
  end

  resources :groups do
    collection do
      get :index
      get :group_details
      get :request_join
      get :join_group
      get :group_page
      get :show_group
      get :group_wall
      get :group_members
      get :group_jobs
      post :add_comment
      post :search_group
      get :group_question
      post :create_question
      get :group_body
      get :faker_join
      get :set_rating
      get :set_salary
      post :update_salary
      get :answer_question
      post :create_answer
      get :render_group_details
      get :group_event
      post :create_event
      get :event_page

    end
  end


  resources :theses do
    collection do
      get :my_theses
      post :create_thesis
      get :download_thesis
      get :thesis_details
      get :thesis_wall
      post :add_comment
      get :thesis_body
      get :thesis_category
      post :search_thesis
      get :my_thesis
      get :delete_thesis
      get :faker_download
      post :update_thesis

    end
  end

  resources :projects do
    collection do
      get :my_projects
      post :create_project
      get :project_details
      get :project_wall
      post :add_comment
      get :project_body
      get :project_category
      post :search_project
      get :delete_project
      post :update_project
      get :join_project
      get :project_invitation
      get :invite_users
      get :invitation_response
      get :project_request
      get :project_wall
      get :project_description

    end
  end

  resources :news do
    collection do
      get :suggest_news
      post :submit_news
      post :news_comment
      get :fetch_news
      get :set_news_rating

    end
  end

  resources :invitations do
    collection do
      #get :project_invitation
      post :send_invitation
    end
  end

  resources :messages do
    collection do
      get :user_inbox
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
