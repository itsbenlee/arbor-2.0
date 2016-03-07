class RegistrationsController < Devise::RegistrationsController
  before_action :resource_name
  skip_before_action :authenticate_user!
  after_action :add_member_to_projects, only: :create

  def after_sign_up_path_for(resource)
    create_template_project
    ArborReloaded::IntercomServices.new(current_user).user_create_event
    if ENV['ENABLE_RELOADED'] == 'false'
      projects_path
    else
      super
    end
  end

  def create # rubocop:disable all
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message(
          :notice,
          "signed_up_but_#{resource.inactive_message}".to_sym
        ) if is_flashing_format?
        expire_data_after_sign_in!
        respond_with(
          resource,
          location: after_inactive_sign_up_path_for(resource)
        )
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      resource.errors.full_messages.each { |message| flash[:alert] = message }
      respond_with resource, location: new_user_session_path
    end
  end

  private

  def resource_name
    :user
  end

  def create_template_project
    project = Project.find_by(is_template: true)
    ArborReloaded::ProjectServices.new(project).replicate_template(current_user)
  end

  def add_member_to_projects
    email = params[:user][:email]

    Invite.where(email: email).each do |invite|
      user = User.find_by(email: email)
      invite.project.add_member(user)
      invite.destroy
    end
  end
end
