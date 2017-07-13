module ArborReloaded
  class SprintUserStoryService
    attr_reader :project, :sprint, :user_story

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

      fail ActiveRecord::RecordNotFound unless sprint_user_story

      sprint_user_story.destroy
    end

    def update_story_status(status = nil)
      delete_user_story && return if status.blank?

      unless SprintUserStory::STATUS.include? status
        fail WrongUserStoryStatusError
      end

      sprint_user_story = SprintUserStory.find_or_create_by(
        user_story_id: @user_story.id,
        sprint_id: @sprint.id
      )

      sprint_user_story.update(status: status)
    end
  end
end
