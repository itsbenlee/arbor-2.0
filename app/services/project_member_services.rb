class ProjectMemberServices
  def initialize(project, current_user, emails)
    @project = project
    @current_user = current_user
    @inviter = current_user.full_name
    @emails = emails
  end

  def invite_members
    project_members = []
    @emails.each do |email|
      project_members << process_email(email)
    end
    @project.members = project_members.compact << @current_user
  end

  private

  def process_email(email)
    user = User.find_by(email: email)
    data = {
      project_name: @project.name,
      email:        email,
      inviter:      @inviter
    }
    if user
      invite_user_to_project(user, data)
      return user
    end

    invite_new_user(data)
    nil
  end

  def invite_user_to_project(user, data)
    return if @project.members.exists?(user.id)
    InviteMailer.project_invite_email(data, false).deliver_now
  end

  def invite_new_user(data)
    @project.invites << Invite.create(email: data[:email])
    InviteMailer.project_invite_email(data, true).deliver_now
  end
end
