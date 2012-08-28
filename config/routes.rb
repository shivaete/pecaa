Mystore3::Application.routes.draw do


  get "product_videos/index"

  get "product_videos/new"

  get "sub_product_options/index"

  get "sub_product_options/new"

  get "product_options/index"

  get "product_options/new"

  resources :system_configs

  resources :product_categories

  resources :product_vendors

  get "model/site_style"

  get "site_pages/index"

  resources :themes do 
    get 'download_theme', :on => :member
    get 'copy_theme', :on => :member
  end
  
  resources :order_ranges

  resources :base_colors

  resources :texts


  resources :sub_permissions

  resources :permissions
  
  get "roles/index"
  post "roles/index"
  resources :roles
  resources :add_files
  resources :add_forms do
    get 'question_detail', :on => :collection
  end
  resources :external_links

  get 'orders_report', :to => 'reports#orders_report'
  
  resources :sites do
    devise_scope :user do
      resources :registrations
      resources :sessions
      resources :passwords
    end

    resources :customer_shippings do
      post :checkout, :on => :collection
    end

    get 'optional', :on => :member
    get 'done', :on => :member
    post 'optional_create', :on => :member
    get 'preview', :on => :member
    post 'site_link_account', :on => :collection
    get 'rendering_partial', :on => :member
    post 'search', :on => :collection
    post 'update_site', :on => :member, :to => 'sites#update'
    get 'pages_list', :on => :collection
    get 'site_preview', :on => :member
    get 'show_products/:view_name(/:qid)', :on => :member, :to => 'sites#show_products'
    get 'accounts/:view_name', :on => :member, :to => 'sites#accounts'
    get 'add_address', :on => :member
    post 'add_address', :on => :member
    
    get 'user_actions', :on => :member
    post 'create_customer', :on => :member
    post 'customer_login', :on => :member
    get 'user_dashboard', :on => :member
    get 'order_history', :on => :member
    get 'system_stats', :on => :collection
    get 'ad_setup', :on => :collection

    
    resources :inventory_options
    resources :gift_certificates do 
      get 'approve', :on => :member
    end
    
    resources :site_vendors 
    resources :coupons do
      get 'approve', :on => :member
    end
    resources :try_it_images
    
    resources :shipping_detials
    resources :shipping_addresses
    resources :billing_addresses
    resources :billings
    resources :reviews do
      get 'approve', :on => :member
    end
    resources :orders do
      get 'product_list', :on => :member
      get 'notes_and_history', :on => :member
      get 'create_notes', :on => :member
      post 'search', :on => :collection
    end
    resources :reports do
      get 'graph_index', :on => :collection
      get 'show_all_products', :on => :collection
      get 'show_custom_fields', :on => :collection
      get 'show_inventory_details', :on => :collection
    end
    
    resources :site_features do 
      get 'change_adv_status', :on => :collection
      get 'ssl_setup_status', :on => :collection
      get 'review_management', :on => :collection
      get 'cart_status',:on => :collection
      get 'rx_manage',:on => :collection
    end

    resources :product_filters do
      get 'update_status', :on => :collection
      get 'enable_status', :on => :member
      post 'rename_editable', :on => :collection
    end
    
    resources :site_pages do
      get 'copy_page', :on => :member
      post 'rename_page', :on => :collection
      get 'destroy_page', :on => :member, :to => 'site_pages#destroy'
      get 'update_page', :on => :member, :to => 'site_pages#update'
      get 'seo_page', :on => :member
      post 'content_new', :on => :member
      post 'content_destroy', :on => :member, :to => 'site_pages#content_destroy'
      post 'content_save', :on => :member, :to => 'site_pages#content_save'
      put 'content_save', :on => :member, :to => 'site_pages#content_save'
      post 'reorder', :on => :collection
      resources :content_libraries do 
        get 'search', :on => :collection
      end
      resources :miscs do
        get 'show_block', :on => :member
      end
    end

    resources :site_styles do
      get 'choose_theme', :on => :collection
      get 'choose_basecolor', :on => :collection
      post 'bgimage_create', :on => :collection
      get 'bg_image', :on => :member
    end

    resources :site_links do
      post 'search', :on => :collection
    end
    
    resources :site_users do
      get 'list_users', :on => :collection 
      get 'list_groups', :on => :collection
      get 'new_group', :on => :collection
      get 'group/:group_id', :on => :collection, :to => 'site_users#group_details'
      get '/user_details/:user_id', :on => :collection, :to => 'site_users#user_details'
      get 'delete', :on => :member
    end
    
    resources :site_ecomm do
      get 'dashboard', :on => :collection 
    end

    resources :carts

    resources :products do
      get 'index', :on => :collection
      get 'featured_products', :on => :collection
      post 'search', :on => :collection
      post 'search_products', :on => :collection
      get 'add_featured', :on => :member, :to => 'products#update'
      get 'images_list', :on => :member
      get 'videos_list', :on => :member
      get 'product_options', :on => :member
      get 'related_products', :on => :member
      get 'remove_rel', :on => :member
      get 'add_category', :on => :member
      get 'remove_category', :on => :member
      post 'search_category', :on => :member
      get 'add_vendor', :on => :member
      get 'remove_vendor', :on => :member
      post 'search_vendors', :on => :member
      get 'product_inventory', :on => :member
      get 'create_inventory', :on => :member
      get 'update_pi', :on => :member, :to => 'products#update_intentory'
      get 'update_product', :on => :member, :to => 'products#update'
      get 'destroy_product', :on => :member, :to => 'products#delete'
      get 'try_it_on', :on => :member
      
      
      resources :product_videos do
        get 'update_pvid', :on => :member, :to => 'product_videos#update'
        get 'delete', :on => :member, :to => 'product_videos#destroy'
        get 'link_video', :on => :member, :to => 'product_videos#link_video'
      end 
      
      resources :product_images do
        get 'update_pimg', :on => :member, :to => 'product_images#update'
        get 'delete', :on => :member, :to => 'product_images#destroy'
      end 
    end
  
    
    resources :product_options do
      get 'update_po', :on => :member, :to => 'product_options#update'
      get 'delete', :on => :member, :to => 'product_options#destroy'
      post 'update_name', :on => :collection
      
      resources :sub_product_options do
        get 'update_spo', :on => :member, :to => 'sub_product_options#update'
        get 'delete', :on => :member, :to => 'sub_product_options#destroy'
        post 'update_price', :on => :member
      end
      
    end
    
    resources :product_categories do 
      post 'search', :on => :collection
      get 'delete', :on => :member, :to => 'product_categories#destroy'
      get 'update_pc', :on => :member, :to => 'product_categories#update'
      post 'update_name', :on => :collection
      post 'reorder', :on => :collection
    end
    
    resources :catalogs do 
      post 'search', :on => :collection
    end
    
    resources :payments do
      get 'enable', :on => :member
    end

    resources :taxs, :only => [:index, :create] do
      get 'enable', :on => :collection
      get 'tax_type', :on => :collection
      get 'destroy', :on => :member
      post 'create_tax_gateway', :on => :collection
      get 'enable_custom', :on => :member
    end

    resources :shippings do
      get 'enable', :on => :member
      get 'destroy_shipping', :on => :member
    end
    
  end
  
  resources :images
  resources :videos


  match 'content_libraries/search', :to=> 'content_libraries#search',:as=>:content_search
  
  resources :content_libraries do
    get 'delete', :on => :member, :to => 'content_libraries#destroy'
  end
  

  match 'colorpicker', :to => "base_colors#colorpicker", :as => :colorpicker 
  
  get "users/index"

#  resources :add_files do
#   member do
#     post 'download'
#   end
#   end
  match 'add_files/download' => 'add_files#download', :as => :download
#  resources :profiles
#
#  match 'profiles/update_state_select/:id', :controller=>'profiles', :action => 'update_state_select'
#
#  match 'profiles/update_city_select/:id', :controller=>'profiles', :action => 'update_city_select'

  # match 'users/list', :to => "users/users#index", :as => :user_list
  # namespace :users do
  #   resources :users
  # end
  
  devise_scope :user do
    get "login"  => "devise/sessions#new"    
    get "logout" => "devise/sessions#destroy"
  end
  post '/users/index'
#  devise_for :users
#  resources :users

# devise_for :users,  :controllers => { :registrations => "users/registrations" }
 resources :users do 
   post 'search', :on => :collection
   get 'update_account', :on => :collection
   get '/user_details/:user_id', :on => :collection, :to => 'users#user_details'
 end

 devise_for :user
#         :path_names => {:sign_in => "", :sign_out => "logout",:sign_up => "register"}


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
   root :to => 'users#dashboard'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   match ':controller(/:action(/:id(.:format)))'
end
