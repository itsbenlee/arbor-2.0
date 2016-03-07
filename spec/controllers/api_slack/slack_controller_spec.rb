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
      expected_url = "https://slack.com/oauth/authorize?scope=commands+incoming-webhook&client_id&redirect_uri=http%3A%2F%2Ftest.host%2Fapi_slack%2Fslack%2Fsend_authorize_data%3Fproject_id%3D#{project.id}"
      expect(response).to redirect_to(expected_url)
    end
  end

  describe 'send_authorize_data' do
    it 'should redirect' do
      get :send_authorize_data, code: '4750359453.21149128567.ac3a1c9bb8', project_id: project.id
      expect(response).to redirect_to(arbor_reloaded_project_user_stories_url(
        project, slack_status: 'success'))
    end
  end
end
