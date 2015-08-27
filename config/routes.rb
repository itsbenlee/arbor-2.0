Railsroot::Application.routes.draw do
  root to: 'projects#index'

  resources :projects,  shallow: true, except: [:destroy] do
    resources :hypotheses, only: [:index, :create]
    resources :canvases, only: [:index, :create]
    resources :user_stories, only: [:create]
    put 'hypotheses/order', controller: :hypotheses, action: :update_order
    get 'hypotheses/export', controller: :hypotheses, action: :export
  end

  resources :hypotheses, only: [:destroy] do
    resources :goals, only: [:create]
  end

  devise_for :users, controllers: { registrations: 'registrations' }
  resources :user_stories, only: [:edit, :update, :destroy]
end
