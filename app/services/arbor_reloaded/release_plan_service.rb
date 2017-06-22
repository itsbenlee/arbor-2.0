module ArborReloaded
  class ReleasePlanService
    attr_reader :plan

    def initialize(project_id, user)
      @project =
        user.projects.includes(sprints: %i(user_stories)).find(project_id)

      @plan = @project.to_release_plan
    end

    def add_sprint
      @project.sprints.create

      @project.to_release_plan
    end

    def delete_sprint(sprint_id)
      @project.sprints.find(sprint_id).destroy
      @project.to_release_plan
    end
  end
end
