ProjTicketsysRefactored::Application.routes.draw do
  
  get "settings/index", :to => 'settings#index', :as => 'settings'
  get 'settings/service_areas', :to => 'settings#service_areas', :as => 'service_areas'
  get 'settings/new_service_area', :to => 'settings#new_service_area', :as => 'new_service_area'
  post 'settings/create_service_area', :to => 'settings#create_service_area', :as => 'create_service_area'
  get 'settings/locations', :to => 'settings#locations', :as => 'locations'
  get 'settings/new_location', :to => 'settings#new_location', :as => 'new_location'
  post 'settings/create_location', :to => 'settings#create_location', :as => 'create_location'
  
  get 'tickets/mytickets', :as => 'mytickets'
  put 'tickets/:id/add_additional_user', :to => 'tickets#add_user',:as => 'add_additional_user'
  put 'tickets/:id/add_additional_provider', :to => 'tickets#add_provider',:as => 'add_additional_provider'
  delete 'tickets/:id/remove_additional_user', :to => 'tickets#remove_user',:as => 'remove_additional_user'  
  put 'tickets/:id/close', :to => 'tickets#close', :as => 'close_ticket'
  put 'tickets/:id/open', :to => 'tickets#open', :as => 'open_ticket'
  
  resources :tickets
  resources :users
  resources :notes, :only => [:new, :create]
  resources :sessions, :only => [:new, :create, :destroy]
  
  get 'signin', :to => 'sessions#new', :as => 'signin'
  delete 'signout', :to => 'sessions#destroy', :as => 'signout'
  #match '/', :to => 'sessions#new'
  root :to  => 'sessions#new'
  
  
  
  
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
