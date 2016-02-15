class SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    ENV['ENABLE_RELOADED'] == 'false' ? projects_path : super
  end
end
