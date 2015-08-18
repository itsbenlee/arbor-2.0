Railsroot::Application.routes.draw do
  devise_for :users
  root to: 'projects#index'

  resources :projects, except: [:destroy] do
    resources :hypotheses, only: [:index, :create]
    resources :canvas, only: [:index, :create]
    put 'hypotheses/order', controller: :hypotheses, action: :update_order
  end

  resources :user_stories, only: [:index, :new, :create]
end
