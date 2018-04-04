Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup', to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # the member method arranges for the routes to respond to URLs containing the user id (users/1/following)
  # 'collection' would do the same as member, but would be without the user id in the url
  resources :users do
    member do
      get :following, :followers
    end
  end
  #gives us get request, url: http://ex.co/account_activation/<token>/edi, edit action, named route: edit_account_activation_url(token)
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
