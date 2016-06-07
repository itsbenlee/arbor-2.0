module ApiSlack
  class SlackController < ApplicationController
    before_action :find_project

    def authorize
      redirect_to ArborReloaded::SlackIntegrationService.new(@project)
        .authorize(send_authorize_data_api_slack_slack_index_url(project_id:
          @project.id))
    end

    def send_authorize_data
      project_id = slack_params['project_id']
      if slack_params['code']
        assign_slack_data
        redirect_to arbor_reloaded_project_user_stories_url(
          project_id: project_id, slack_status: 'success')
      else
        redirect_to arbor_reloaded_project_user_stories_url(
          project_id: project_id, slack_status: 'error')
      end
    end

    def toggle_notifications
      if current_user.can_delete?(@project)
        @project.update_attributes(slack_enabled: !@project.slack_enabled)
        response = { success: true }
        status = 200
      else
        response = { authorized: false }
        status = 403
      end
      render json: response, status: status
    end

    def test_auth
      slack_data = ArborReloaded::SlackIntegrationService.new(@project)
                   .req_slack_data(current_user.slack_auth_token)
      render json: { authorized: slack_data['ok'] }, status: 200
    end

    private

    def assign_slack_data
      slack_data = ArborReloaded::SlackIntegrationService.new(@project)
                   .req_slack_access(slack_params['code'],
                   send_authorize_data_api_slack_slack_index_url(project_id:
                    @project.id))
      assign_slack_user
      return unless slack_data['ok']
      assign_data(slack_data)
    end

    def assign_data(slack_data)
      incoming_webhook = slack_data['incoming_webhook']
      ArborReloaded::IntercomServices.new(current_user)
        .create_event(t('intercom_keys.slack_connect'))
      assign_slack_token(slack_data['access_token'])
      assign_slack_channel(incoming_webhook['url'],
        incoming_webhook['channel_id'])
    end

    def assign_slack_token(token)
      current_user.update_attribute(:slack_auth_token, token)
    end

    def assign_slack_channel(url, channel)
      @project.update_attributes(
        slack_iw_url: url,
        slack_channel_id: channel,
        slack_enabled: true)
    end

    def assign_slack_user
      slack_data = ArborReloaded::SlackIntegrationService.new(@project)
                   .req_slack_data(current_user.slack_auth_token)
      return unless slack_data['ok']
      current_user.update_attribute(:slack_id, slack_data['user_id'])
    end

    def find_project
      @project = Project.find(slack_params['project_id'])
    end

    def slack_params
      params.permit(:project_id, :code)
    end
  end
end
