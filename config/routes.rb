Railsroot::Application.routes.draw do
  devise_for :users
  root to: 'projects#index'

  resources :projects, except: [:destroy] do
    resources :hypotheses, only: [:index, :create]
    resources :canvas, only: [:index, :create]
  end
end
