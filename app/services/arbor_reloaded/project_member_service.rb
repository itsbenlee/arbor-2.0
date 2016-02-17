module ArborReloaded
  class ProjectMemberService
    def initialize(project, current_user, email)
      @project = project
      @current_user = current_user
      @inviter = current_user.full_name
      @email = email
    end

    def invite_member
      user = User.find_by(email: @email)
      data = {
        project_name: @project.name,
        email:        @email,
        inviter:      @inviter
      }
      if user
        invite_user_to_project(user, data)
      else
        invite_new_user(data)
      end
    end

    private

    def invite_user_to_project(user, data)
      return if @project.members.exists?(user.id)
      InviteMailer.project_invite_email(data, false).deliver_now
      @project.add_member(user)
    end

    def invite_new_user(data)
      email = data[:email]

      @project.invites <<
        Invite.create(email: email) unless @project.invite_exists(email)
      InviteMailer.project_invite_email(data, true).deliver_now
    end
  end
end
