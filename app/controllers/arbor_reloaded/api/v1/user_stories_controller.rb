module ArborReloaded
  module Api
    module V1
      class UserStoriesController < ApiBaseController
        before_action :set_project, only: :create

        def create
          params[:user_stories].each do |story|
            story_params = story.permit(:description, :estimated_points)
            @project.user_stories.create(story_params)
          end

          render json: @project.as_json
        end

        private

        def set_project
          @project = current_user.projects.find(params[:project_id])
        end
      end
    end
  end
end
