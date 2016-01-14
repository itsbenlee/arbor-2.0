require 'spec_helper'

RSpec.describe ArborReloaded::UserStoriesController do
  let!(:user)        { create :user }
  let!(:project)     { create :project, owner: user }
  let!(:project2)     { create :project, owner: user }
  let!(:user_story)  { create :user_story, project: project}

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

      expect(UserStory.count).to eq(2)
    end
  end

  describe 'POST copy' do
    it 'copies some stories' do
      post :copy, format: :js, project_id: project2.id,
        user_stories: [project.user_stories.last.id]
      expect(project2.user_stories.last.role).to eq(project.user_stories.last.role)
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
