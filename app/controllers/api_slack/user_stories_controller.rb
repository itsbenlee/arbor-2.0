module ApiSlack
  class UserStoriesController < ApplicationController
    layout false
    skip_before_action :authenticate_user!
    protect_from_forgery with: :null_session

    def create
      project = Project.find(slack_params[:project_id])
      story_text = slack_params[:text]
      slack_integration_service =
        ArborReloaded::SlackIntegrationService.new(project)
      response =
        slack_integration_service.build_user_story(story_text, current_user)

      render json: response, status: (response.success ? 201 : 422)
    end

    private

    def slack_params
      params.permit([:text, :project_id])
    end
  end
end
