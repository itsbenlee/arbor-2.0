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

feature 'update acceptance criterion' do
  let(:user_story)           { create :user_story }
  let(:criterion_service)    { AcceptanceCriterionServices.new(user_story) }
  let(:acceptance_criterion) {
    create :acceptance_criterion,
    user_story: user_story,
    description: 'This is the description.'
  }

  scenario 'should load the response with user story edit url' do
    response = criterion_service.update_acceptance_criterion(acceptance_criterion)

    expect(response.success).to eq(true)
    expect(response.data[:edit_url]).to eq(edit_user_story_path(user_story))
  end
end

feature 'delete acceptance criterion' do
  let(:user_story)           { create :user_story }
  let(:criterion_service)    { AcceptanceCriterionServices.new(user_story) }
  let(:acceptance_criterion) {
    create :acceptance_criterion,
    user_story: user_story
  }

  scenario 'should load the response with user story edit url' do
    response = criterion_service.delete_acceptance_criterion(acceptance_criterion)

    expect(response.success).to eq(true)
    expect(response.data[:edit_url]).to eq(edit_user_story_path(user_story))
  end
end
