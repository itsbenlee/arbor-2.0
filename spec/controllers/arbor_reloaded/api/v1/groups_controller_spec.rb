require 'spec_helper'

RSpec.describe ArborReloaded::Api::V1::GroupsController do
  let!(:user)    { create :user }
  let!(:project) { create :project, owner: user }

  describe 'without user' do
    describe '#create' do
      before do
        request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Token.encode_credentials('fake credentials')
        post :create, { project_id: project.id, group: { name: 'test' } }
      end

      it 'should return an unauthorization code' do
        expect(response.code.to_i).to eq(401)
      end
    end
  end

  describe 'for common user' do
    describe '#create' do
      before do
        request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Token.encode_credentials(user.access_token)

        post :create, { project_id: project.id, group: { name: 'test' } }
        @hash_response = JSON.parse(response.body)
      end

      it 'should return a success code' do
        expect(response.code.to_i).to eq(200)
      end

      it 'shoud add the group on database' do
        expect(Project.last.groups.count).to eq(1)
      end

      it 'should return the right name' do
        expect(@hash_response['name']).to eq('test')
      end
    end
  end
end
