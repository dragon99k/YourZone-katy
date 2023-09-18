Rails.application.routes.draw do
  get 'users/show'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_for :admin, controllers: {
    sessions: 'admin/sessions',
      # registrations: 'admin/registrations'
  }

  root to: "communities#index"
  mount ActionCable.server => '/cable'

  resources :communities do
    resources :community_topics
    member do
      post :favorite
      put :un_favorite
      put :approve_community
    end
    collection do
      get :list_favorite_community
      get :list_user_favorite
      get :list_user_wait_to_approve
    end
    resources :community_images, only: %i[show], module: :communities
  end

  resource :profile, only: [:show, :edit, :update] do
    member do
      get :visits
    end
  end
  resources :chatrooms, only: [:index, :show, :create] do
    resources :messages, only: [:create, :destroy]
  end
  resources :users, only: [:show, :destroy] do
    member do
      post :follow
      post :like
      post :block
      put :un_block
    end
    collection do
      get :user_blockers
      get :list_user_wait_to_approve_community
    end

    collection do
      resources :community_notifications, only: %i[index], module: :users do
        put :seen, on: :collection
      end
    end
  end

  resources :list_word_founds

  # add router
  namespace :admin do
    root to: "users#index"

    # resources :dashboard, only: [:index]
    resources :users, only: %i[index destroy]
    resources :communities, only: %i[index destroy]
    resources :messages, only: %i[index]
  end

  namespace :push_notifications do
    post :save_token
    post :destroy_token
  end

  resources :list_favorites, only: [:index] do
    collection do
      get "list_user_favorites"
    end
  end

  resources :community_rooms do
    resources :community_messages, only: [:create]
  end

  resources :notifications

  resources :cancel_memberships, only: [:update] do
    collection do
      post "check_user_for_login"
      put "update_user_active"
    end
  end
end
