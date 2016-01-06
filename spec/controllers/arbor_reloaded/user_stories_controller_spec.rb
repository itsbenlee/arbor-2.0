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
end
