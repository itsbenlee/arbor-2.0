class SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    ENV['ENABLE_RELOADED'] == 'true' ? arbor_reloaded_root_path : super
  end
end
