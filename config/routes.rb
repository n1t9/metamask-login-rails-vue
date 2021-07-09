Rails.application.routes.draw do
  root to: 'welcome#index'

  namespace :api do
    resources :users, only: %i[index create] do
      post :signin, on: :collection
      delete :signout, on: :collection
    end
  end
end
