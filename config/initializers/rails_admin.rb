RailsAdmin.config do |config|
  config.authorize_with do
    authenticate_or_request_with_http_basic('Log In') do |username, password|
      username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
    end
  end

  config.actions do
    dashboard
    index
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end

  config.included_models = %w(User Project UserStory AcceptanceCriterion)

  config.model User do
    object_label_method { :email }
    list { field :email }
    show { field :email }
    edit { field :email }
  end

  config.model Project do
    object_label_method { :name }

    list { field :name }
    show { field :name }
    edit { field :name }
  end

  config.model UserStory do
    list do
      field :role
      field :action
      field :result
      field :estimated_points
    end

    show do
      field :role
      field :action
      field :result
      field :estimated_points
    end

    edit do
      field :role
      field :action
      field :result
      field :estimated_points
    end
  end

  config.model AcceptanceCriterion do
    object_label_method { :description }

    list { field :description }
    show { field :description }
    edit { field :description }
  end
end
