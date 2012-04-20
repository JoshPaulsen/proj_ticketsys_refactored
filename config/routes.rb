ProjTicketsysRefactored::Application.routes.draw do
  
  put 'service_area_forms/:id/move_up', :to => 'service_area_forms#move_up', :as => 'move_up'
  put 'service_area_forms/:id/move_down', :to => 'service_area_forms#move_down', :as => 'move_down'
  post 'service_area_forms/:id/set_providers', :to => 'service_area_forms#set_providers', :as => 'set_providers'
  delete 'service_area_forms/remove_field/:id', :to => 'service_area_forms#remove_field', :as => 'remove_field'  
  post 'service_area_forms/:id/create_field', :to => 'service_area_forms#create_field', :as => 'create_form_field'
  get 'service_area_forms/:id/new_field', :to => 'service_area_forms#new_field', :as => 'new_form_field'  
  
  
  get 'tickets/search', :as => 'search'
  get 'tickets/new_ticket', :to => 'tickets#new_ticket', :as => 'continue_new_ticket'
  get 'tickets/my_tickets', :as => 'my_tickets'
  put 'tickets/:id/set_primary_provider', :to => 'tickets#set_primary_provider',:as => 'set_primary_provider'
  put 'tickets/:id/add_additional_user', :to => 'tickets#add_user',:as => 'add_additional_user'
  put 'tickets/:id/add_additional_provider', :to => 'tickets#add_provider',:as => 'add_additional_provider'
  delete 'tickets/:id/remove_additional_user', :to => 'tickets#remove_user',:as => 'remove_additional_user'  
  put 'tickets/:id/close', :to => 'tickets#close', :as => 'close_ticket'
  put 'tickets/:id/open', :to => 'tickets#open', :as => 'open_ticket'
  
  put 'users/:id/deactivate', :to => 'users#deactivate', :as => 'deactivate_user'
  put 'users/:id/reactivate', :to => 'users#reactivate', :as => 'reactivate_user'  
  
  put 'locations/:id/deactivate', :to => 'locations#deactivate', :as => 'deactivate_location'
  put 'locations/:id/reactivate', :to => 'locations#reactivate', :as => 'reactivate_location'
  
  put 'service_areas/:id/deactivate', :to => 'service_areas#deactivate', :as => 'deactivate_service_area'
  put 'service_areas/:id/reactivate', :to => 'service_areas#reactivate', :as => 'reactivate_service_area'
  
  resources :service_areas, :except => [:new, :show]
  resources :locations, :except => [:new, :show]
  resources :service_area_forms
  resources :tickets
  resources :users
  resources :notes, :only => [:new, :create]
  resources :sessions, :only => [:new, :create, :destroy]
  
  get "settings/index", :as => 'settings'
  
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
