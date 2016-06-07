require 'spec_helper'

RSpec.describe ApiSlack::SlackController do
  let!(:user) { create :user }
  let!(:project) { create :project, owner: user }

  before :each do
    sign_in user
  end

  describe 'authorize' do
    it 'should redirect to the slack auth' do
      get :authorize, project_id: project.id
      expected_url = "https://slack.com/oauth/authorize?scope=commands+incoming-webhook&client_id=#{ENV['SLACK_CLIENT_ID']}&redirect_uri=http%3A%2F%2Ftest.host%2Fapi_slack%2Fslack%2Fsend_authorize_data%3Fproject_id%3D#{project.id}"
      expect(response).to redirect_to(expected_url)
    end
  end

  describe 'send_authorize_data' do
    it 'should redirect' do
      get :send_authorize_data, code: 'VALID_CODE', project_id: project.id
      expect(response).to redirect_to(arbor_reloaded_project_user_stories_url(
        project, slack_status: 'success'))
    end
  end

  describe 'toggle_notifications' do
    it 'should enable slack notifications' do
      notifications = project.slack_enabled
      get :toggle_notifications, project_id: project.id, format: :json
      expect(Project.find(project.id).slack_enabled).to eq(!notifications)
    end

    it 'should disable slack notifications' do
      project.update_attribute(:slack_enabled, true)
      expect{ get :toggle_notifications, project_id: project.id, format: :json }
          .to change{Project.find(project.id).slack_enabled}.from(true).to(false)
    end
  end
end
