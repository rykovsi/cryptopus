Cryptopus::Application.routes.draw do
  resources :recryptrequests
  resources :teams do
    resources :teammembers
    resources :groups do
      resources :accounts do
        resources :items
      end
    end
  end

  namespace :admin do
    resources :ldapsettings
    resources :users
    resources :recryptrequests do
      collection do
        post 'resetpassword'
      end
    end
  end

  resource :login do
    get 'login'
    get 'pwdchange'
    post 'pwdchange'
    get 'logout'
    get 'noaccess'
    post 'authenticate'
    post 'changelocale'
  end



  get 'wizard', to: 'wizard#index'
  post 'wizard/apply'

  get 'search', to: 'search#index'
  get 'search/account', to: 'search#account'

  root to: 'search#index'
end

