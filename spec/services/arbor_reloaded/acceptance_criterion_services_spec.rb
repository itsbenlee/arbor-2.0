require 'spec_helper'

feature 'create acceptance criterion' do
  let(:user)       { create :user }
  let(:project)    { create :project }
  let(:user_story) { create :user_story }
  let(:ac_service) { ArborReloaded::CriterionServices.new(user_story) }
  let(:ac_params)  {
    {
      user_story_id: user_story.id,
      description: 'My new description'
    }
  }

  background do
    allow_any_instance_of(ArborReloaded::IntercomServices)
      .to receive(:criterion_create_event).and_return(true)
  end

  scenario 'should create an Acceptance Criterion and assign the user story' do
    ac = ac_service.new_acceptance_criterion(ac_params, user)
    expect(ac).to be_a(AcceptanceCriterion)
    expect(ac.description).to eq('My new description')
    expect(ac.user_story).to eq(user_story)
    expect(ac.order).to eq(1)
    expect(ac).to eq(AcceptanceCriterion.last)
  end

  scenario 'should assign the correct order' do
    ac_service.new_acceptance_criterion(ac_params, user)
    second_ac = ac_service.new_acceptance_criterion(
      { user_story_id: user_story.id, description: 'Other description' }, user)

    expect(second_ac.order).to eq(2)
  end
end
