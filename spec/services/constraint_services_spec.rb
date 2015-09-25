require 'spec_helper'

feature 'create constraint' do
  let(:project)    { create :project }
  let(:user_story) { create :user_story }
  let(:constraint_service) { ConstraintServices.new(user_story) }
  let(:constraint_params)  {
    {
      user_story_id: user_story.id,
      description: 'My new description'
    }
  }

  scenario 'should create a Constraint and assign the user story' do
    response = constraint_service.new_constraint(constraint_params)
    expect(response.success).to eq(true)
    constraint = Constraint.last
    expect(constraint).to be_a(Constraint)
    expect(constraint.description).to eq('My new description')
    expect(constraint.user_story).to eq(user_story)
  end
end
