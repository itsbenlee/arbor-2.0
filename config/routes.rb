Railsroot::Application.routes.draw do
  devise_for :users
  root to: 'projects#index'

  resources :projects, only: [:index, :new, :create, :show] do
    resources :hypotheses, only: [:index, :create]
  end
end
