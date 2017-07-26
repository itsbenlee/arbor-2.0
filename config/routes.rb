Railsroot::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_scope :user do
    authenticated :user do
      root to: 'arbor_reloaded/projects#index', as: :authenticated_root
    end

    unauthenticated :user do
      root to: 'devise/sessions#new'
    end
  end

  devise_for :users,
    controllers: { registrations: 'registrations' }

  namespace :arbor_reloaded do
    root to: 'projects#index'

    get 'feedback' => redirect(ENV['FEEDBACK_URL'])
    get 'projects/list', controller: :projects, action: :list_projects

    post 'read-updates', to: 'users#read_updates'
    get 'updates' => redirect(ENV['UPDATES_URL']) if ENV['UPDATES_URL']

    resources :projects, except: [:new, :edit], shallow: true do
      resources :trello, only: [:new, :create, :index, :update]
      get 'export_to_google', controller: :google_sheets,
                              action: :export
      get 'export_to_board', controller: :trello,
                             action: :export_to_board
      get 'export_backlog', controller: :projects,
                            action: :export_backlog
      get 'log', on: :member
      get 'members', controller: :projects,
                     action: :members
      resources :canvas, only: [:index, :create],
                         as: :canvases,
                         controller: :canvases
      put 'user_stories/order', controller: :projects,
                                action: :order_stories,
                                as: :reorder_backlog

      resources :backlog,
          only: [:create, :index, :show, :update, :destroy, :new],
          as: :user_stories,
          controller: :user_stories do
        resources :acceptance_criterions, only: [:create, :update, :destroy]
        resources :comments, only: [:create, :destroy]

        collection do
          get :ungrouped
        end

        member do
          put :color
        end
      end

      put 'add_member', controller: :projects, action: :add_member
      put 'join', controller: :projects, action: :join_project

      get '/list_backlog', controller: :projects, action: :backlog
      resources :attachments, only: [:index, :create, :destroy]

      post '/copy', controller: :projects, action: :copy

      delete 'remove_member_from_project',
        controller: :projects,
        action: :remove_member_from_project

      get 'members', controller: :projects, action: :members

      resources :groups, only: %i(index create update destroy) do
        member do
          patch :up
          patch :down
          patch :active
          patch :inactive
        end
      end

      member do
        get :release_plan
        put :starting_date
      end

      resources :sprints, only: :create, shallow: true
    end

    resources :google_sheets, only: [] do
      get :authorization_callback, on: :collection
    end

    get 'export/:id/spreadhseet', to: 'projects#export_to_spreadhseet'

    post 'user_stories/copy', controller: :user_stories, action: :copy

    delete 'user_stories/destroy_stories',
      controller: :user_stories,
      action: :destroy_stories

    resources :users, only: :show

    put 'users/ajax_update',
      controller: :users,
      action: :ajax_update

    namespace :api, defaults: { format: :json } do
      namespace :v1 do
        resources :projects, only: :create, shallow: true do
          resources :groups, only: :create
          resources :release_plans, only: :index
          resources :user_stories, only: :create, shallow: true do
            resources :acceptance_criterions, only: :create
          end
        end
      end
    end

    resources :sprint_user_stories, only: :create
  end

  namespace :api_slack do
    resources :user_stories, only: [:create]
    resources :slack do
      collection do
        get :authorize
        get :send_authorize_data
        get :toggle_notifications
        get :test_auth
      end
    end
  end

  get ENV['LETS_ENCRYPT_ROUTE'],
    controller: :well_known,
    action: :index
end
