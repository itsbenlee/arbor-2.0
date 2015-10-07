class TagServices
  def initialize(project, user_story = nil)
    @project = project
    @user_story = user_story
    @common_response = CommonResponse.new(true, [])
    @route_helper = Rails.application.routes.url_helpers
  end

  def new_tag(tag_params)
    tag = Tag.new(tag_params)
    assign_associations(tag)

    if tag.save
      assign_common_response(tag)
    else
      @common_response.success = false
      @common_response.errors += tag.errors.full_messages
    end
    @common_response
  end

  private

  def assign_associations(tag)
    tag.project = @project
    tag.user_stories << @user_story if @user_story
  end

  def assign_common_response(tag)
    @user_story.tags << tag
    @common_response.data[:edit_url] =
      @route_helper.edit_user_story_path(@user_story)
  end
end
