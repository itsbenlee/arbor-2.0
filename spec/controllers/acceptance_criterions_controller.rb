require 'spec_helper'

RSpec.describe AcceptanceCriterionsController do
  describe 'POST create' do
    before :each do
      user = create :user
      @project = create :project, owner: user
      @user_story = create :user_story, project: @project
      sign_in user
    end

    context 'for a new criterion' do
      it 'should create criterion' do
        request.env["HTTP_REFERER"] = project_user_stories_path(@project.id)
        post :create, user_story_id: @user_story.id, acceptance_criterion:{ description: 'My new description'}
        expect(response).to be_redirect
        expect(AcceptanceCriterion.count).to eq(1)
      end

      it 'should edit criterion' do
        acceptance_criterion = create :acceptance_criterion,
        user_story: @user_story

        request.env["HTTP_REFERER"] = project_user_stories_path(@project.id)
        updated_description = 'My updated description'

        put :update, id: acceptance_criterion.id,acceptance_criterion:{ description: updated_description}

        acceptance_criterion.reload
        expect(acceptance_criterion.description).to eq(updated_description)
      end
    end
  end
end
