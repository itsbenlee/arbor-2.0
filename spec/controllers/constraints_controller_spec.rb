require 'spec_helper'

RSpec.describe ConstraintsController do
  describe 'POST create' do
    let!(:user)       { create :user }
    let!(:project)    { create :project, owner: user }
    let!(:user_story) { create :user_story, project: project }

    before :each do
      sign_in user
    end

    context 'for a new constraint' do
      it 'should create constraint' do
        request.env["HTTP_REFERER"] = project_user_stories_path project
        post(
          :create,
          user_story_id: user_story.id,
          constraint:    { description: 'My new description' }
        )
        expect(response).to be_redirect
        expect(Constraint.count).to eq 1
      end

      it 'should edit constraint' do
        constraint = create :constraint, user_story: user_story

        request.env["HTTP_REFERER"] = project_user_stories_path project
        updated_description = 'My updated description'

        put(
          :update,
          id:         constraint.id,
          constraint: { description: updated_description }
        )

        constraint.reload
        expect(constraint.description).to eq updated_description
      end
    end
  end
end
