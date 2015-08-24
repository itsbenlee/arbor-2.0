require 'spec_helper'

feature 'Create a new epic' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let(:epic)        { build :epic }

  background do
    sign_in user
    visit project_hypotheses_path project
  end

  scenario 'should show me an epic creation form for each hypothesis' do
    expect(page).to have_css 'form.new_user_story'
    %w(Role Action Result).each do |input|
      expect(page).to have_field input
    end
  end

  scenario 'should create a new epic' do
    within 'form.new_user_story' do
      fill_in 'Role', with: epic.role
      fill_in 'Action', with: epic.action
      fill_in 'Result', with: epic.result
      expect{ click_button 'Save' }.to change { UserStory.count }.by 1
    end
  end
end
