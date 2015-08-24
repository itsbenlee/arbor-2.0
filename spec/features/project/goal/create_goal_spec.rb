require 'spec_helper'

feature 'Create a new goal' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let(:goal)        { build :goal }

  background do
    sign_in user
    visit project_hypotheses_path project
  end

  scenario 'should show me a goal creation form for each hypothesis' do
    expect(page).to have_css 'form.new_goal'
    within 'form.new_goal' do
      expect(page).to have_field :goal_title
    end
  end

  scenario 'should create a new goal' do
    within 'form.new_goal' do
      fill_in 'goal_title', with: goal.title
      expect{ click_button 'Save' }.to change { Goal.count }.by 1
    end
  end
end
