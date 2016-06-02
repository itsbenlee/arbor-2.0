class CommentServices
  def initialize(user_story)
    @user_story = user_story
    @common_response = CommonResponse.new(true, [])
    @route_helper = Rails.application.routes.url_helpers
  end

  def new_comment(params)
    comment = Comment.new(params)
    @user_story.comments << comment

    if comment.save
      assign_response_and_activity(params)
    else
      @common_response.success = false
      @common_response.errors += comment.errors.full_messages
    end
    @common_response
  end

  private

  def assign_response_and_activity(params)
    @user_story.project.create_activity :add_comment,
      owner: params[:user],
      parameters:
        { user_story: @user_story.log_description, comment: params[:comment] }
    @common_response.data[:edit_url] =
      @route_helper.arbor_reloaded_project_user_stories_path(@user_story)
  end
end
