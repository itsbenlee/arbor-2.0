class UserStoryService
  def new_user_story(user_story_params, project)
    @user_story = UserStory.new(user_story_params)
    @user_story.project = project
    @user_story
  end
end
