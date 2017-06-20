RSpec.describe ArborReloaded::Api::V1::ReleasePlansController do
  let(:user)       { create :user }
  let(:other_user) { create :user }
  let(:project)    { create :project, owner: user }

  describe '.index' do
    describe 'without user' do
      before do
        get :index, project_id: project.id
      end

      describe 'response code' do
        subject { response.code }

        it { should eq '401' }
      end
    end

    describe 'with user' do
      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(
          user.access_token
        )

        get :index, project_id: project.id
      end

      describe 'response code' do
        subject { response.code }

        it { should eq '200' }
      end

      describe 'response body' do
        subject { JSON.parse(response.body) }
        it { should include('name' => project.name) }
      end
    end

    describe 'as a user who is not the project owner' do
      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(
          other_user.access_token
        )

        get :index, project_id: project.id
      end

      describe 'response code' do
        subject { response.code }

        it { should eq '404' }
      end
    end
  end
end
