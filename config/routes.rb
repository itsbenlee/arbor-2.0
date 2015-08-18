Railsroot::Application.routes.draw do
  devise_for :users
  root to: 'projects#index'

  resources :projects, except: [:destroy] do
    resources :hypotheses, only: [:index, :create]
    resources :canvas, only: [:index, :create]
    resources :user_stories, only: [:create, :edit, :update]
    put 'hypotheses/order', controller: :hypotheses, action: :update_order
  end
end
