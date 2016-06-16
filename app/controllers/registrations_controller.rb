class RegistrationsController < Devise::RegistrationsController
  before_action :resource_name
  skip_before_action :authenticate_user!
  after_action :invites, only: :create

  def after_sign_up_path_for(resource)
    create_user_resources
    super
  end

  def create
    super do
      resource.errors.full_messages.each { |message| flash[:alert] = message }
    end
  end

  def update
    super do
      resource.errors.full_messages.each { |message| flash[:alert] = message }
    end
  end

  private

  def resource_name
    :user
  end

  def create_user_resources
    ArborReloaded::IntercomServices.new(current_user).user_create_event
    project = Project.find_by(is_template: true)
    ArborReloaded::ProjectServices.new(project).replicate_template(current_user)
  end

  def invites
    return unless resource.errors.empty?
    project_invites
    team_invites
  end

  def project_invites
    Invite.for_projects(resource.email).each do |invite|
      invite.project.add_member(resource)
      invite.destroy
    end
  end

  def team_invites
    Invite.for_teams(resource.email).each do |invite|
      invite.team.users << resource
      invite.destroy
    end
  end
end
