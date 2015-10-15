class TagServices
  def initialize(user_story = nil)
    @user_story = user_story
    @common_response = CommonResponse.new(true, [])
  end

  def new_tag(tag_params)
    tag = Tag.new(tag_params)
    assign_associations(tag)

    if tag.save
      @common_response.data[:edit_url] =
        Rails.application.routes.url_helpers.edit_user_story_path(@user_story)
    else
      @common_response.success = false
      @common_response.errors += tag.errors.full_messages
    end
    @common_response
  end

  def tag_search(project)
    tags = project.tags
    if tags.count > 0
      @common_response.data[:tags] = tags.map(&:name)
    else
      @common_response.success = false
    end
    @common_response
  end

  private

  def assign_associations(tag)
    tag.project = @user_story.project
    tag.user_stories << @user_story
  end
end
