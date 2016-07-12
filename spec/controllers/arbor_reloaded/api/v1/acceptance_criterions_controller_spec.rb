require 'spec_helper'

RSpec.describe ArborReloaded::Api::V1::AcceptanceCriterionsController do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }

  describe 'without user' do
    describe '#create' do
      before do
        request.env['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Token.encode_credentials('fake credentials')

        post :create, { user_story_id: user_story.id,
                        acceptance_criterions: [{ description: 'test' },
                                                { description: 'test2' }] }
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

        post :create, { user_story_id: user_story.id,
                        acceptance_criterions: [{ description: 'test' },
                                                { description: 'test2' }] }
      end

      it 'should return a success code' do
        expect(response.code.to_i).to eq(200)
      end

      it 'should increase acceptance criterions on database' do
        expect(user_story.acceptance_criterions.count).to eq(2)
      end

      it 'should return the right acceptance criterions description' do
        response_hash = JSON.parse(response.body)
        expect(response_hash['acceptance_criterions'][0]['description']).to eq('test')
        expect(response_hash['acceptance_criterions'][1]['description']).to eq('test2')
      end

      it 'should return the right acceptance criterions amount' do
        response_hash = JSON.parse(response.body)
        expect(response_hash['acceptance_criterions'].length).to eq(2)
      end
    end

    describe '#duplicated_create' do
      before do
        request.env['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Token.encode_credentials(user.access_token)

        post :create, { user_story_id: user_story.id,
                        acceptance_criterions: [{ description: 'test' },
                                                { description: 'test2' }] }

        post :create, { user_story_id: user_story.id,
                        acceptance_criterions: [{ description: 'test' },
                                                { description: 'test2' }] }
      end

      it 'should return a success code' do
        expect(response.code.to_i).to eq(200)
      end

      it 'should increase acceptance criterions on database' do
        expect(user_story.acceptance_criterions.count).to eq(2)
      end

      it 'should return the right acceptance criterions description' do
        response_hash = JSON.parse(response.body)
        expect(response_hash['acceptance_criterions'][0]['description']).to eq('test')
        expect(response_hash['acceptance_criterions'][1]['description']).to eq('test2')
      end

      it 'should return the right acceptance criterions amount' do
        response_hash = JSON.parse(response.body)
        expect(response_hash['acceptance_criterions'].length).to eq(2)
      end
    end
  end
end
