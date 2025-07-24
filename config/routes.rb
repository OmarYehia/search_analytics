Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      post 'search_terms', to: 'search_terms#create'
      # get 'analytics', to: 'search_analytics#index' # Was used for testing. Uncomment if needed
      get 'search_analytics/top_terms', to: 'search_analytics#top_terms'
      get 'search_analytics/trends', to: 'search_analytics#trends'
      get 'search_analytics/user_activity', to: 'search_analytics#user_activity'
    end
  end
end
