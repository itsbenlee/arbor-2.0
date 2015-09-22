class UserStoryService
  def initialize(project, hypothesis)
    @common_response = CommonResponse.new(true, [])
    @project = project
    @hypothesis = hypothesis
  end

  def new_user_story(user_story_params)
    user_story = UserStory.new(user_story_params)
    update_associations(user_story)

    if user_story.save
      @common_response.data[:user_story_id] = user_story.id
    else
      @common_response.success = false
      @common_response.errors += user_story.errors.full_messages
    end

    @common_response
  end

  def update_associations(user_story)
    user_story.project = @project
    @project.user_stories << user_story

    return unless @hypothesis
    @hypothesis.user_stories << user_story
    user_story.hypothesis = @hypothesis
  end
end
