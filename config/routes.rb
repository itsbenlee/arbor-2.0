Railsroot::Application.routes.draw do
  devise_scope :user do
    authenticated :user do
      root to: 'arbor_reloaded/projects#index', as: :authenticated_root
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
    get 'tag/delete', controller: :tags, action: :delete

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

    delete 'remove_member_from_project',
      controller: :projects,
      action: :remove_member_from_project

    resources :archives, only: :index
    get '/list_archived', controller: :archives, action: :list_archived
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

  devise_for :users,
    controllers: { registrations: 'registrations', sessions: 'sessions' }

  namespace :arbor_reloaded do
    root to: 'projects#index'

    get 'projects/list', controller: :projects, action: :list_projects

    resources :projects, except: [:new, :edit], shallow: true do
      resources :trello, only: [:new, :create, :index, :update]
      get 'export_to_board',
        controller: :trello,
        action: :export_to_board
      get 'export_backlog',
        controller: :projects,
        action: :export_backlog
      get 'log', on: :member
      get 'members',
          controller: :projects,
          action: :members
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
          only: [:create, :index, :show, :update, :destroy],
          as: :user_stories,
          controller: :user_stories do
        resources :acceptance_criterions, only: [:create, :update, :destroy]
        resources :constraints, only: [:create, :update]
        resources :tags, only: [:create, :index]
        resources :comments, only: [:create, :destroy]
      end

      put 'add_member', controller: :projects, action: :add_member
      put 'join', controller: :projects, action: :join_project

      get 'tags/filter', controller: :tags, action: :filter
      get 'tags/index', controller: :tags, action: :index
      get 'tag/delete', controller: :tags, action: :delete

      get '/list_backlog', controller: :projects, action: :backlog
      resources :attachments, only: [:index, :create, :destroy]

      post '/copy', controller: :projects, action: :copy

      delete 'remove_member_from_project',
        controller: :projects,
        action: :remove_member_from_project

      get 'members', controller: :projects, action: :members
    end

    post 'user_stories/copy', controller: :user_stories, action: :copy

    delete 'user_stories/destroy_stories',
      controller: :user_stories,
      action: :destroy_stories

    resources :users, only: [:update, :show]
    resources :teams, only: [:index, :create, :destroy] do
      put 'add_member', controller: :teams, action: :add_member
      delete 'remove_member', controller: :teams, action: :remove_member
    end

    get 'team_members', controller: :teams, action: :members

    put 'users/ajax_update',
      controller: :users,
      action: :ajax_update
  end

  namespace :api_slack do
    resources :user_stories, only: [:create]
    resources :slack, only: [:authorize, :send_authorize_data] do
      collection do
        get :authorize
        get :send_authorize_data
      end
    end
  end
end
