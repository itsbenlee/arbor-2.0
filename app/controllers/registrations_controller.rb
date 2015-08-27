class RegistrationsController < Devise::RegistrationsController
  before_action :resource_name
  skip_before_action :authenticate_user!
  after_action :add_member_to_projects, only: :create

  def new
    redirect_to new_user_session_path
  end

  def create
    super
  end

  private

  def resource_name
    :user
  end

  def add_member_to_projects
    email = params[:user][:email]
    Invite.where(email: email).each do |invite|
      invite.project.members << User.find_by(email: email)
      Invite.destroy(invite)
    end
  end
end
