module ArborReloaded
  class UserStoryService
    def initialize(project)
      @common_response = CommonResponse.new(true, [])
      @project = project
    end

    def slack_user_story(user_story_params, current_user)
      user_story = new_user_story(user_story_params, current_user)
      if user_story
        assign_response(user_story)
      else
        @common_response.success = false
        @common_response.errors += user_story.errors.full_messages
      end
      @common_response
    end

    def new_user_story(user_story_params, current_user)
      user_story = UserStory.new(user_story_params)
      user_story.project = @project
      if user_story.save
        ArborReloaded::IntercomServices
          .new(current_user).create_event(I18n.t('intercom_keys.create_story'))
        create_activity(user_story, current_user)
      end
      user_story
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
      user_stories.each { |story| story.copy_in_project(@project.id) }
    end

    def destroy_stories(user_stories)
      @common_response.work do
        user_stories
          .select { |story| !@project.user_stories.find(story).destroy }
          .map { |story| "Error destroying user_story: #{story}" }
      end
    end

    private

    def assign_response(user_story)
      route_helper = Rails.application.routes.url_helpers
      route = route_helper.arbor_reloaded_project_user_stories_path(user_story)
      @common_response.data = { user_story_id: user_story.id, edit_url: route }
    end

    def create_activity(user_story, current_user)
      @project.create_activity :add_user_story,
        owner: current_user,
        parameters: { user_story: user_story.log_description }
    end
  end
end
