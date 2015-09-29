require 'spec_helper'

feature 'create acceptance criterion' do
  let(:project)    { create :project }
  let(:user_story) { create :user_story }
  let(:ac_service) { AcceptanceCriterionServices.new(user_story) }
  let(:ac_params)  {
    {
      user_story_id: user_story.id,
      description: 'My new description'
    }
  }

  scenario 'should create an Acceptance Criterion and assign the user story' do
    response = ac_service.new_acceptance_criterion(ac_params)
    expect(response.success).to eq(true)
    ac = AcceptanceCriterion.last
    expect(ac).to be_a(AcceptanceCriterion)
    expect(ac.description).to eq('My new description')
    expect(ac.user_story).to eq(user_story)
  end
end
