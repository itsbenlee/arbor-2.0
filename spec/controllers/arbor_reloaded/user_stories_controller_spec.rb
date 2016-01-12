require 'spec_helper'

RSpec.describe ArborReloaded::UserStoriesController do
  let!(:user)        { create :user }
  let!(:project)     { create :project, owner: user }

  before :each do
    sign_in user
  end

  describe 'POST create' do
    it 'creates a user story' do
      post :create, format: :js, project_id: project.id, user_story: {
          role: 'user',
          action: 'sign up',
          result: 'i can browse the site',
          estimated_points: '3',
          priority: 'should',
        }

      expect(UserStory.count).to eq(1)
    end
  end

  describe 'PUT update' do
    let(:user_story) { create :user_story, estimated_points: 5 }

    it 'updates a user story' do
      put :update, format: :json, id: user_story.id, user_story: {
          estimated_points: '3' }

      hash_response = JSON.parse(response.body)
      user_story.reload

      expect(hash_response['success']).to eq(true)
      expect(hash_response['data']['id']).to eq(user_story.id)
      expect(hash_response['data']['estimated_points']).to eq(user_story.estimated_points)
    end
  end
end
