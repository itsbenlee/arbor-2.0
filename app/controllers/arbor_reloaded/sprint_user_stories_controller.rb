module ArborReloaded
  class SprintUserStoriesController < ApplicationController
    before_action :set_status
    before_action :set_service

    def create
      @sprint_user_story_service.update_story_status(
        @status
      )

      project
      sprint
      user_story
    end

    private

    def set_status
      @status = params[:status]
    end

    def set_service
      @sprint_user_story_service = ArborReloaded::SprintUserStoryService.new(
        current_user,
        params[:project_id],
        params[:sprint_id],
        params[:user_story_id]
      )
    end

    def project
      @project = @sprint_user_story_service.project.reload
    end

    def sprint
      @sprint = @sprint_user_story_service.sprint
    end

    def user_story
      @user_story = @sprint_user_story_service.user_story
    end
  end
end
