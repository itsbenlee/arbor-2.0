module ApiSlack
  class UserStoriesController < ApplicationController
    layout false
    skip_before_filter :verify_authenticity_token
    skip_before_action :authenticate_user!
    protect_from_forgery with: :null_session
    @project = nil
    @user = nil

    def create
      preprocess_post
      response = ArborReloaded::SlackIntegrationService.new(@project)
                 .build_user_story(slack_params[:text], @user)
      render json: success_response(response),
             status: (response.success ? 201 : 422)
    rescue StandardError
      render json: error_response, status: false
    end

    private

    def preprocess_post
      check_slack_params
      set_project_using_slack_id
      set_user
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

    def set_user
      @user = @project.owner
    end

    def success_response(response)
      user_story_id = response.data[:user_story_id]
      title_link = edit_user_story_url(user_story_id)
      {
        response_type: 'in_channel',
        text: 'New user story created',
        attachments: [
          {
            title: "US#: #{user_story_id}",
            title_link: title_link,
            text: "User story #{user_story_id} created with success.\n" \
              "You can edit it in #{title_link}",
            color: '#28D7E5'
          }
        ]
      }
    end

    def error_response
      {
        response_type: 'in_channel',
        text: 'Error creating US',
        attachments: [
          {
            title: 'Error',
            text: 'An internal error occurred.',
            color: '#D50200'
          }
        ]
      }
    end
  end
end
