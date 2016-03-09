class ReloadedStoryService
  def initialize(project)
    @project = project
  end

  def new_user_story(user_story_params, current_user)
    user_story = UserStory.new(user_story_params)
    user_story.project = @project
    ArborReloaded::IntercomServices.new(user).user_story_create_event
    create_activity(user_story, current_user) if user_story.save
    user_story
  end

  private

  def create_activity(user_story, current_user)
    @project.create_activity :add_user_story,
      owner: current_user,
      parameters: { user_story: user_story.log_description }
  end
end
