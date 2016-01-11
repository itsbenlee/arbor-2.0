require 'spec_helper'

RSpec.describe ArborReloaded::AcceptanceCriterionsController do

  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }

  before :each do
    sign_in user
  end

  describe 'POST create' do
    it 'should create a criterion' do
      expect {
        post(
        :create,
        format: :js,
        user_story_id:        user_story.id,
        acceptance_criterion: { description: 'My new description'}
        )
      }.to change { AcceptanceCriterion.count }.by 1

      expect(AcceptanceCriterion.last.description).to eq('My new description')
    end
  end
end
