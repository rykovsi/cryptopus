# frozen_string_literal: true

#  Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
#  Cryptopus and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/cryptopus.

Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get 'status/health', to: 'status#health'
  get 'status/readiness', to: 'status#readiness'

  namespace :recryptrequests do
    get 'new_ldap_password'
    post 'recrypt'
  end

  resources :teams do
    resources :api_users, only: [:index, :create, :destroy], module: 'api/team'
    resources :teammembers
    resources :groups do
      resources :accounts do
        put 'move', to: 'accounts#move'
        resources :items
      end
    end
  end

  namespace :admin do
    resources :maintenance_tasks, only: :index
    post '/maintenance_tasks/:id/execute', to: 'maintenance_tasks#execute', as: 'maintenance_tasks_execute'

    resource :settings do
      post 'update_all'
      get 'index'
    end

    resources :users, except: :destroy do
      member do
        get 'unlock'
      end
    end

    resources :recryptrequests do
      collection do
        post 'resetpassword'
      end
    end

    get  'teams', to: 'teams#index'
  end

  resource :login, except: :show do
    post 'changelocale'
  end

  get 'wizard', to: 'wizard#index'
  post 'wizard/apply'

  get 'search', to: 'search#index'

  root to: 'search#index'

  get 'changelog', to: 'changelog#index'

  get 'profile', to: 'profile#index'

  scope '/api', module: 'api' do

    resources :groups, only: [:index]
    resources :teams, only: [:index]
    resources :accounts, only: [:show, :index, :update]

    resources :api_users do
      member do
        get :token, to: 'api_users/token#show'
        delete :token, to: 'api_users/token#destroy'
        post :lock, to: 'api_users/lock#create'
        delete :lock, to: 'api_users/lock#destroy'
      end
    end

    resources :accounts, only: [:show]
    scope '/search', module: 'search' do
      get :accounts
      get :groups
      get :teams
    end

    scope '/admin', module: 'admin' do
      resources :users, only: :destroy do
        member do
          patch :update_role, to: 'users/role#update'
        end
      end
      resources :ldap_connection_test, only: ['new']
    end

    resources :accounts, only: ['show']

    # INFO don't mix scopes and resources in routes
    resources :teams, only: [:destroy, :index]  do
      collection do
        get :last_teammember_teams
      end
      resources :groups, only: ['index'], module: 'team'
      resources :members, except: [:new, :edit], module: 'team' do
        collection do
          get :candidates
        end
      end
    end
  end
end
