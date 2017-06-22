module ArborReloaded
  class SprintUserStoryService
    def initialize(user, project_id, sprint_id, user_story_id)
      @project =
        user.projects.includes(:sprints, :user_stories).find(project_id)

      @sprint = @project.sprints.find(sprint_id)
      @user_story = @project.user_stories.find(user_story_id)
    end

    def delete_user_story
      sprint_user_story = SprintUserStory.find_by(
        user_story_id: @user_story.id,
        sprint_id: @sprint.id
      )

      raise ActiveRecord::RecordNotFound unless sprint_user_story

      sprint_user_story.destroy
    end
  end
end
