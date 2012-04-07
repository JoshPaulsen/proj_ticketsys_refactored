ProjTicketsysRefactored::Application.routes.draw do
  
  
  delete  'ticket_forms/remove_field/:id', :to => 'ticket_forms#remove_field', :as => 'remove_field'  
  post    'ticket_forms/:id/create_field', :to => 'ticket_forms#create_field', :as => 'create_form_field'
  get     'ticket_forms/:id/new_field', :to => 'ticket_forms#new_field', :as => 'new_form_field'  
  
  get    'tickets/new_ticket', :to => 'tickets#new_ticket', :as => 'continue_new_ticket'
  get     'tickets/mytickets', :as => 'mytickets'
  post    'tickets/new_ticket_form', :as => 'new_ticket_form'
  put     'tickets/:id/addwatcher', :to => 'tickets#addwatcher',:as => 'addwatcher'
  delete  'tickets/:id/removewatcher', :to => 'tickets#removewatcher',:as => 'removewatcher'
  put     'tickets/:id/close', :to => 'tickets#close', :as => 'close_ticket'
  put     'tickets/:id/open', :to => 'tickets#open', :as => 'open_ticket'
  
  resources :tickets
  resources :users
  resources :notes, :only => [:new, :create]
  resources :sessions, :only => [:new, :create, :destroy]
  resources :ticket_forms
  
  get "settings/index", :as => 'settings'
  
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/', :to => 'sessions#new'
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
