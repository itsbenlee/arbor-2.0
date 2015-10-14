require 'spec_helper'

RSpec.describe ConstraintsController do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }

  before :each do
    sign_in user
  end

  describe 'POST create' do
    context 'for a new constraint' do
      it 'should create constraint' do
        request.env["HTTP_REFERER"] = project_user_stories_path project
        post(
          :create,
          user_story_id: user_story.id,
          constraint:    { description: 'My new description' }
        )

        expect { Constraint.count }.to become_eq 1
        hash_response = JSON.parse(response.body)
        expect(hash_response['success']).to eq(true)
        expect(hash_response['data']['edit_url']).to eq(edit_user_story_path(user_story))
      end
    end
  end

  describe 'PUT update' do
    let!(:constraint) { create :constraint, user_story: user_story }

    it 'sends a success response with the edit url' do
      updated_description = 'This is the new description.'
      request.env['HTTP_REFERER'] = project_user_stories_path(project.id)
      put :update, id: constraint.id, constraint: {
          description: updated_description
        }

      constraint.reload
      expect(constraint.description).to eq updated_description
      user_story = constraint.user_story
      hash_response = JSON.parse(response.body)

      expect(hash_response['success']).to eq(true)
      expect(hash_response['data']['edit_url']).to eq(edit_user_story_path(user_story))
    end
  end
end
