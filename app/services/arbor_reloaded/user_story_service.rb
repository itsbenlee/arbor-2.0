module ArborReloaded
  class UserStoryService
    def initialize(project)
      @common_response = CommonResponse.new(true, [])
      @project = project
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
        @common_response.data =
          { estimated_points: user_story.estimated_points,
            total_points: @project.reload.total_points,
            total_cost: "$#{@project.total_cost}",
            total_weeks: @project.total_weeks,
            id: user_story.id }
      else
        @common_response.success = false
        @common_response.errors += user_story.errors.full_messages
      end
      @common_response
    end

    def copy_stories(user_stories)
      user_stories.each { |story| story.copy_in_project(@project.id, nil) }
    end

    def destroy_stories(user_stories)
      @common_response.work do
        user_stories
          .select { |story| !@project.user_stories.find(story).destroy }
          .map { |story| "Error destroying user_story: #{story}" }
      end
    end

    private

    def assign_response_and_activity(user_story, current_user)
      route_helper = Rails.application.routes.url_helpers

      @project.create_activity :add_user_story,
        owner: current_user,
        parameters: { user_story: user_story.log_description }

      common_response_data = @common_response.data
      common_response_data[:user_story_id] = user_story.id
      common_response_data[:edit_url] =
        route_helper.edit_user_story_path(user_story)
    end

    def update_associations(user_story)
      user_story.project = @project
      @project.user_stories << user_story
    end
  end
end
