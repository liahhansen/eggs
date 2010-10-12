Eggs::Application.routes.draw do
  resources :email_templates
  resources :snippets
  match 'feedbacks' => 'feedbacks#create', :as => :feedback
  match 'feedbacks/new' => 'feedbacks#new', :as => :new_feedback
  resources :locations
  resources :transactions
  match 'ipn' => 'transactions#ipn', :as => :ipn
  resources :password_resets
  resources :activation_resets
  resources :members
  match '/register/:activation_code' => 'activations#new', :as => :register
  match '/activate/:id' => 'activations#create', :as => :activate
  match 'join' => 'members#new', :as => :join
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'essential_info' => 'farms#show_essential_info', :as => :essential_info
  resources :user_sessions
  resources :order_items
  resources :orders
  resources :subscriptions
  resources :users
  resources :stock_items
  resources :deliveries do
  
  
      resources :orders
  end

  resources :products
  resources :product_questions
  resources :farms do
  
  
      resources :deliveries do
    
    
          resources :orders
    end
  end

  match '/' => 'home#index'
  match '/:controller(/:action(/:id))'
end
