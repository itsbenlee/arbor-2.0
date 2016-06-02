require 'spec_helper'

RSpec.describe ArborReloaded::Api::V1::UserStoriesController do
  let!(:user)    { create :user }
  let!(:project) { create :project, owner: user }

  describe 'without user' do
    describe '#create' do
      before do
        request.env['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Token.encode_credentials('fake credentials')
        post :create, { project_id: project.id }
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

        post :create, { project_id: project.id,
                        user_stories: [{ description: 'test', estimated_points: 4 },
                                       { description: 'test2', estimated_points: 2 }] }
      end

      it 'should return a success code' do
        expect(response.code.to_i).to eq(200)
      end

      it 'should return the right user story description' do
        response_hash = JSON.parse(response.body)
        expect(response_hash['user_stories'][0]['description']).to eq('test2')
        expect(response_hash['user_stories'][1]['description']).to eq('test')
      end

      it 'should return the right user story description' do
        response_hash = JSON.parse(response.body)
        expect(response_hash['user_stories'][0]['estimated_points']).to eq(2)
        expect(response_hash['user_stories'][1]['estimated_points']).to eq(4)
      end

      it 'should return the right user stories amount' do
        response_hash = JSON.parse(response.body)
        expect(response_hash['user_stories'].length).to eq(2)
      end
    end
  end
end
