module ArborReloaded
  class ReleasePlanService
    def initialize(project_id, user)
      @project = user.projects
                     .includes(sprints: %i(user_stories))
                     .find(project_id)
    end

    def plan
      {
        name: @project.name,
        sprints: @project.sprints.map(&:as_json)
      }
    end
  end
end
