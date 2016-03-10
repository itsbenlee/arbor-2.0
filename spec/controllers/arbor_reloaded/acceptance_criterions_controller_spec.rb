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
      allow_any_instance_of(ArborReloaded::IntercomServices)
        .to receive(:criterion_create_event).and_return(true)

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

  describe 'DELETE destroy' do
    let!(:acceptance_criterion) { create :acceptance_criterion, user_story: user_story }

    it 'deletes the criterion' do
      delete :destroy, format: :js, id: acceptance_criterion.id
      expect(AcceptanceCriterion.exists? acceptance_criterion.id).to be_falsy
    end
  end
end
