class RegistrationsController < Devise::RegistrationsController
  before_action :resource_name
  skip_before_action :authenticate_user!

  def new
    redirect_to new_user_session_path
  end

  private

  def resource_name
    :user
  end
end
