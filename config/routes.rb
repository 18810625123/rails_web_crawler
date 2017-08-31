Rails.application.routes.draw do

  namespace :crawler do
    resources :website_types
  end
  namespace :crawler do
    get '/' => 'base#index'

    resources :websites

    resources :plans do
      collection do
      end
      member do
        get :exce
        post :exce
      end
    end
    resources :menus do
      collection do

      end
      member do
        get :move
      end
    end
    resources :works do
      collection do
        get :tj
        post :tj
        get :wj
        post :wj
        get :handle
        post :handle
      end
      member do
      end
    end
  end

  # 城市四级联动
  resources :streets
  resources :cities
  resources :provinces

  # resources :crawler_sys, :only => [:index,:show] do

  mount HelloApi, at: '/api/'

  root 'welcome#index'
end
