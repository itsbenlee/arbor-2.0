class UserStoryService
  def initialize(project, hypothesis = nil)
    @common_response = CommonResponse.new(true, [])
    @project = project
    @hypothesis = hypothesis
    @route_helper = Rails.application.routes.url_helpers
  end

  def new_user_story(user_story_params, current_user)
    user_story = UserStory.new(user_story_params)
    update_associations(user_story)

    if user_story.save
      assign_response_and_activity(user_story, current_user)
    else
      @common_response.success = false
      @common_response.errors += user_story.errors.full_messages
    end
    @common_response
  end

  def update_user_story(user_story)
    if user_story.save
      @common_response.data[:edit_url] =
        @route_helper.edit_user_story_path(user_story)
    else
      @common_response.success = false
      @common_response.errors += user_story.errors.full_messages
    end
    @common_response
  end

  def copy_stories(user_stories)
    user_stories.each { |story| story.copy_in_project(@project.id, nil) }
  end

  private

  def assign_response_and_activity(user_story, current_user)
    @project.create_activity :add_user_story,
      owner: current_user,
      parameters: { user_story: user_story.log_description }

    common_response_data = @common_response.data
    common_response_data[:user_story_id] = user_story.id
    common_response_data[:edit_url] =
      @route_helper.edit_user_story_path(user_story)
  end

  def update_associations(user_story)
    user_story.project = @project
    @project.user_stories << user_story

    return unless @hypothesis
    @hypothesis.user_stories << user_story
    user_story.hypothesis = @hypothesis
  end
end
