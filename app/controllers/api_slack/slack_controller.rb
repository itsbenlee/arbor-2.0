module ApiSlack
  class SlackController < ApplicationController
    def authorize
      @project = find_project
      redirect_to ArborReloaded::SlackIntegrationService.new(@project)
        .authorize(send_authorize_data_api_slack_slack_index_url(project_id:
          @project.id))
    end

    def send_authorize_data
      project_id = params['project_id']
      if params['code']
        assign_slack_data
        redirect_to arbor_reloaded_project_user_stories_url(
          project_id: project_id, slack_status: 'success')
      else
        redirect_to arbor_reloaded_project_user_stories_url(
          project_id: project_id, slack_status: 'error')
      end
    end

    private

    def assign_slack_data
      @project = find_project
      slack_data = ArborReloaded::SlackIntegrationService.new(@project)
                   .req_slack_access(params['code'],
                   send_authorize_data_api_slack_slack_index_url(project_id:
                    @project.id))
      assign_slack_user
      return unless slack_data['ok']
      assign_data(slack_data)
    end

    def assign_data
      ArborReloaded::IntercomServices.new(current_user)
        .create_event(t('intercom_keys.slack_connect'))
      assign_slack_token(slack_data['access_token'])
      assign_slack_channel(slack_data['incoming_webhook'])
    end

    def assign_slack_token(token)
      current_user.update_attribute(:slack_auth_token, token)
    end

    def assign_slack_channel(incoming_webhook)
      @project = find_project
      @project.update_attribute(:slack_iw_url, incoming_webhook['url'])
      @project
        .update_attribute(:slack_channel_id, incoming_webhook['channel_id'])
    end

    def assign_slack_user
      @project = find_project
      slack_data = ArborReloaded::SlackIntegrationService.new(@project)
                   .req_slack_data(current_user.slack_auth_token)
      return unless slack_data['ok']
      current_user.update_attribute(:slack_id, slack_data['user_id'])
    end

    def find_project
      Project.find(params['project_id'])
    end
  end
end
