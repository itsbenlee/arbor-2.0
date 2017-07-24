module ArborReloaded
  class UpdateProjectStartDateService
    def initialize(project_id, current_user)
      @project =
        current_user.projects.includes(:groups, :user_stories, :sprints).find(
          project_id
        )
    end

    def starting_date(date)
      @project.update(starting_date: date)
    end

    def release_plan
      @project.reload.to_release_plan
    end
  end
end
