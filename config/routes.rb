Site::Application.routes.draw do

  # Administration
  namespace :admin do
    resources :articles, :except => [:index, :show] do
      member do
        get "commit"
        get "publish"
        get "unpublish"
      end
    end

    get "/" => "admin#index"
  end

  match "login"      => "user#login",      :via => :post, :as => :login
  match "logout"     => "user#logout",     :via => :get,  :as => :logout
  match "login_form" => "user#login_form", :via => :get
  match "login"      => "user#login_form", :via => :get,  :as => :login_form

  # Articles
  match "articles/multiple/:quantity" => "articles#multiple", :as => :show_multiple_aritcles
  match "articles/multiple/:quantity/from/:offset" => "articles#multiple", :as => :show_multiple_articles_with_offset
  match "articles/page/:page" => "articles#multiple", :as => :articles_page
  resources :articles, :only => [:index, :show]

  # Tags
  match "tags/multiple/:keywords" => "tags#show_multiple", :as => :show_multiple_tags
  resources :tags, :only => [:index, :show]

  # Root
  root :to => "articles#index"

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
  # match ':controller(/:action(/:id(.:format)))'
end
