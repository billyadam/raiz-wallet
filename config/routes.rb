Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :users, only: [:login] do
      collection do
        post 'login'
        get 'profile'
        get 'wallet'
      end
    end

    get 'users', to: 'users#index'

    resources :transactions, only: [:transfer, :deposit, :withdraw] do
      collection do
        post 'transfer'
        post 'deposit'
        post 'withdraw'
      end
    end
  end
end
