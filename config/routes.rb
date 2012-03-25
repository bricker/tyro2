Tyro::Application.routes.draw do
  # OPTIMIZE use :only and :except to weed out all unnecessary routes - may improve performance
  
  match 'feed' => 'home#feed'
  match 'display/playlist' => 'display#playlist'
  
  get 'home' => 'home#index', :as => :home
  get 'schedule' => 'home#schedule', :as => :schedule
  get 'sources' => 'home#sources', :as => :sources
  get 'playlist' => 'home#playlist', :as => :playlist
  get 'news' => 'home#news', :as => :news
  get 'blog' => 'blogs#index', :as => :blog
  get 'podcast' => 'podcasts#index', :as => :podcast
  
  get 'update_playlist' => 'home#update_playlist'
  get 'update_current_events' => 'home#update_current_events'  
  get 'update_next_event' => 'home#update_next_event'  
  
  get '/livecam/:cam' => 'home#livecam', :as => :livecam

  match 'explore(/:search_type)' => 'home#explore', :as => :explore
  
  resources :tags, :only => [:index, :show]
    
  get 'about' => 'about#history', :as => :about
  get 'contact' => 'about#contact', :as => :contact
  get 'channels' => 'about#channels', :as => :channels
  get 'submissions' => 'about#submissions', :as => :submissions
  
  get 'stream(/:channel)' => 'home#stream', :as => :stream
  get 'stream/audio/:channel' => 'home#channel_redirect'
  get 'streams/audio/:channel' => 'home#channel_redirect'
    
  resources :shows, :only => :show do
    get 'update_playlist', :on => :collection, :defaults => { :format => :js }
  end
  
  resources :events, :only => [:index, :show] do
    get 'birn1' => 'events#index', :event_type => 'birn1', :on => :collection, :as => :birn1
    get 'birn2' => 'events#index', :event_type => 'birn2', :on => :collection, :as => :birn2
    get 'birn-presents' => 'events#index', :event_type => 'birn-presents', :on => :collection, :as => :birn_presents
  end
    
  get 'join' => 'cp/signups#new', :as => :join
  
  namespace :cp do
    
    #sessions
    match 'login' => 'sessions#new', :as => :login
    match 'logout' => 'sessions#destroy', :as => :logout
    match 'resources' => 'home#resources', :as => :resources
    match 'tin_news' => 'home#tin_news', :as => :tin_news
    
    get "guest-request" => "guest_requests#new", :as => :guest_request
    post "guest-request" => "guest_requests#create", :as => :guest_request
    
    resources :sessions, :only => [:new, :create, :destroy] do 
      get 'emails', :as => :emails, :on => :collection
    end
    
    resource :profile, :only => [:show, :edit, :update] do
      get 'strikes'
      get 'edit_password'
      put 'update_password'
      get 'training_progress'
    end
    
    resources :signups, :news_posts
    resources :static_contents, :only => [:index, :edit, :update]
    
    resources :password_resets, :only => [:new, :create, :edit, :update]
    resources :comments, :except => [:index, :show, :new]
    resources :training_steps, :except => [:show]
        
    resources :schedule_events do
      resources :playlist_entries do
        match 'playlist', :as => :playlist, :on => :collection
      end # playlist_entries
      put 'move' => 'schedule_events#move', :on => :member
      collection do 
        get 'schedule'
        get 'calendar'
        post 'recur'
      end
    end
        
    resources :events do
      get 'playlist', :on => :member
    end
    
    resources :forums, :except => :show do
      resources :topics, :only => [:index, :new, :create] #added index for backwards-compatibility
      get 'subscribe' => 'subscriptions#subscribe', :as => :subscribe
      get 'unsubscribe' => 'subscriptions#unsubscribe', :as => :unsubscribe
      #get '/' => 'topics#index'#, :as => :topics # This breaks /new. Bummer.
    end #forums
    
    resources :topics, :except => :show do
      resources :messages, :only => [:index, :new, :create] #added index for backwards-compatibility
      collection do
        get 'unread'
        get 'mark_read'
      end
      
      get 'subscribe' => 'subscriptions#subscribe', :as => :subscribe
      get 'unsubscribe' => 'subscriptions#unsubscribe', :as => :unsubscribe
      get '/' => 'messages#index'#, :as => :messages 
    end #topics
    
    resources :messages, :except => :show
    
    resources :problem_reports do      
      member do
        post 'toggle_status'
        get 'comments' => 'problem_reports#show'
      end
      
      resources :comments, :only => :create
    end #problem reports
    
    resources :users do
      resources :comments, :only => :create
      resources :strikes, :except => :show do
        post 'toggle_resolved', :on => :member
      end
      resource :training_progress, :only => [:show, :edit, :update], :controller => 'training_progress'
      
      member do
        get 'edit_password'
        put 'update_password'
        
        get 'comments'
        
        get 'edit_remove'
        put 'remove'
        
        get 'edit_permissions'
        put 'update_permissions'
        
        get 'manage'
        put 'update_manage'
        
        put 'resend_welcome'
      end
      
      collection do
        get 'search'
        get 'new_multiple'
        post 'create_multiple'
      end
    end #users
        
    resources :shows do
      resources :posts, :except => :show
      resources :shouts, :substitutes
      resources :schedule_events, :only => [:index, :new, :create]
      
      collection do
        get 'search'
        get 'full_schedule'
      end
      
      member do
        get 'schedule'
        get 'playlist(/:schedule_event_id)' => 'shows#playlist', :as => :playlist
        get 'edit_manage'
        put 'update_manage'
      end
    end # shows
    
    root :to => 'home#index'  

    if Rails.env.production?
      match '*path' => 'home#index'
    end

  end #cp
  
  root :to => 'home#index'
  
  if Rails.env.production?
    match '*path' => 'home#index'
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
