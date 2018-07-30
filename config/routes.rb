Rails.application.routes.draw do
  devise_for :users, skip: :sessions
  # Api definition
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1,
                  constraints: ApiConstraints.new(version: 1, default: true) do

      resources :users, only: [:show, :create, :update, :destroy] do
        resources :products, only: [:create, :update]
      end

      resources :sessions, only: [:create, :destroy]
      resources :products, only: [:show, :index]
    end
  end
end
