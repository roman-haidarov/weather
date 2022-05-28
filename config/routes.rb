Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :weather do
        collection do
          get :current
          get :historical
          get "/historical/max", to: 'weather#max'
          get "/historical/min", to: 'weather#min'
          get "/historical/avg", to: 'weather#avg'
          get :by_time
        end
      end
    end
  end

  resources :health, only: :index
end
