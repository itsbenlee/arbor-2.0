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
      @common_response.data[:edit_url] =
        @route_helper.edit_user_story_path(@user_story)
    else
      @common_response.success = false
      @common_response.errors += comment.errors.full_messages
    end
    @common_response
  end
end
