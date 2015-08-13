class ProjectAuthorization
  def initialize(project)
    @project = project
  end

  def member?(user)
    @project.members.map(&:id).include?(user.id)
  end
end
