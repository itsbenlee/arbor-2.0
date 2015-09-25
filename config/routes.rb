Railsroot::Application.routes.draw do
  devise_scope :user do
    authenticated :user do
      root to: 'projects#index', as: :authenticated_root
    end

    unauthenticated :user do
      root to: 'devise/sessions#new'
    end
  end

  resources :projects, shallow: true do
    get 'log', on: :member
    resources :hypotheses, only: [:index, :create, :update]
    resources :canvases, only: [:index, :create]
    put 'user_stories/order',
        controller: :projects,
        action: :order_stories,
        as: :reorder_backlog

    resources :user_stories, except: [:show, :new] do
      resources :acceptance_criterions, only: [:create, :update]
      resources :constraints, only: [:create, :update]
    end

    put 'hypotheses/order', controller: :hypotheses, action: :update_order
    get 'hypotheses/export', controller: :hypotheses, action: :export
    get 'hypotheses/export/trello',
      controller: :hypotheses,
      action: :export_to_trello,
      as: :trello_export

    put 'hypotheses/user_stories/order',
      controller: :user_stories,
      action: :update_order,
      as: :user_stories_order

    get '/backlog', controller: :projects, action: :backlog
    resources :attachments, only: [:index, :create]
  end

  resources :hypotheses, only: [:destroy] do
    resources :goals, only: [:create]
    get '/user_stories', controller: :hypotheses, action: :list_stories
  end

  resources :goals, only: [:edit, :update, :destroy]

  devise_for :users, controllers: { registrations: 'registrations' }
end
