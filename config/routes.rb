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
    resources :lab,
      only: [:index, :create, :update],
      as: :hypotheses,
      controller: :hypotheses
    resources :canvas,
      only: [:index, :create],
      as: :canvases,
      controller: :canvases
    put 'user_stories/order',
        controller: :projects,
        action: :order_stories,
        as: :reorder_backlog

    resources :backlog,
        except: [:show, :new],
        as: :user_stories,
        controller: :user_stories do
      resources :acceptance_criterions, only: [:create, :update]
      resources :constraints, only: [:create, :update]
      resources :tags, only: [:create, :index]
      resources :comments, only: [:create]
    end

    get 'user_stories/export',
      controller: :user_stories,
      action: :export,
      as: :backlog_export

    get 'tags/filter', controller: :tags, action: :filter
    get 'tags/index', controller: :tags, action: :index

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

    get '/list_backlog', controller: :projects, action: :backlog
    resources :attachments, only: [:index, :create, :destroy]

    post '/copy', controller: :projects, action: :copy
  end

  resources :lab,
    only: [:destroy],
    as: :hypotheses,
    controller: :hypotheses do
    resources :goals, only: [:create]
    get '/user_stories', controller: :hypotheses, action: :list_stories
  end

  resources :constraints, only: :destroy
  resources :acceptance_criterions, only: :destroy

  post 'user_stories/copy', controller: :user_stories, action: :copy
  resources :goals, only: [:edit, :update, :destroy]

  put 'user_stories/order_criterions',
      controller: :user_stories,
      action: :reorder_criterions,
      as: :reorder_criterions

  put 'user_stories/order_constraints',
      controller: :user_stories,
      action: :reorder_constraints,
      as: :reorder_constraints

  get 'export/:id/spreadhseet', to: 'projects#export_to_spreadhseet'

  devise_for :users, controllers: { registrations: 'registrations' }
end
