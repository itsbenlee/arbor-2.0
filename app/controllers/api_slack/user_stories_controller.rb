module ApiSlack
  class UserStoriesController < ApplicationController
    layout false
    skip_before_action :authenticate_user!
    protect_from_forgery with: :null_session
    @project = nil
    @user = nil

    def create
      preprocess_post
      response =
        ArborReloaded::SlackIntegrationService.new(@project)
        .build_user_story(slack_params[:text], @user)
      render json: response, status: (response.success ? 201 : 422)
    rescue StandardError => error
      render json: CommonResponse.new(false, [error.message]), status: false
    end

    private

    def preprocess_post
      check_slack_params
      set_project_using_slack_id
      set_user_using_slack_id
      check_project_member_relationship
    end

    def slack_params
      params.permit(:text, :channel_id, :user_id)
    end

    def check_slack_params
      slack_params
        .fetch(:text) { fail ArgumentError, 'text is missing' }
      slack_params
        .fetch(:channel_id) { fail ArgumentError, 'channel_id is missing' }
      slack_params
        .fetch(:user_id) { fail ArgumentError, 'user_id is missing' }
    end

    def check_project_member_relationship
      fail("User doesn't have permissions on project") unless
        MembersProject.find_by(member_id: @user.id, project_id: @project.id)
    end

    def set_project_using_slack_id
      @project = Project.find_by(slack_channel_id: slack_params[:channel_id])
      fail(
        "Can't find project related to the given slack channel id"
      ) unless @project
    end

    def set_user_using_slack_id
      @user = User.find_by(slack_id: slack_params[:user_id])
      fail("Can't find user with the given user id") unless @user
    end
  end
end
