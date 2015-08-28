Railsroot::Application.routes.draw do
  root to: 'projects#index'

  resources :projects,  shallow: true do
    resources :hypotheses, only: [:index, :create]
    resources :canvases, only: [:index, :create]
    resources :user_stories, only: [:create]
    put 'hypotheses/order', controller: :hypotheses, action: :update_order
    get 'hypotheses/export', controller: :hypotheses, action: :export
    put 'hypotheses/user_stories/order',
      controller: :user_stories,
      action: :update_order,
      as: :user_stories_order
  end

  resources :hypotheses, only: [:destroy] do
    resources :goals, only: [:create]
  end

  resources :goals, only: [:edit, :update, :destroy]

  devise_for :users, controllers: { registrations: 'registrations' }
  resources :user_stories, only: [:edit, :update, :destroy]
end
