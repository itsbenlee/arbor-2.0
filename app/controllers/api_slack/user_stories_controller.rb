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
    rescue StandardError => error
      render json: error_response(error), status: false
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
      fail('PROJECT_NOT_FOUND') unless @project
    end

    def set_user
      @user = @project.owner
    end

    def success_response(response)
      user_story = UserStory.find(response.data[:user_story_id])
      {
        response_type: 'in_channel',
        attachments: [
          {
            title: t('slack.notifications.story_created'),
            text: t('slack.notifications.user_story',
              user_story: user_story.log_description,
              link: arbor_reloaded_project_user_stories_url(@project)),
            color: '#28D7E5'
          }
        ]
      }
    end

    def error_response(error)
      {
        response_type: 'in_channel',
        attachments: [
          {
            title: t('slack.notifications.story_error_title'),
            text: error_text(error),
            color: '#D50200'
          }
        ]
      }
    end

    def error_text(error)
      error = error.to_s
      if error == 'PROJECT_NOT_FOUND'
        text = t('slack.notifications.no_configured_error', link: 'getarbor.io')
      elsif error == 'EMPTY'
        text = t('slack.notifications.empty_error')
      else
        text = t('slack.notifications.default_error')
      end
      text
    end
  end
end
