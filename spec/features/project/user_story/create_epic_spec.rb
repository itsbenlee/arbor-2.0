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
    %w(user_story_role user_story_action user_story_result).each do |input|
      expect(page).to have_field input
    end
  end

  scenario 'should create a new epic' do
    within 'form.new_user_story' do
      fill_in 'user_story_role', with: epic.role
      fill_in 'user_story_action', with: epic.action
      fill_in 'user_story_result', with: epic.result
      expect{ click_button 'Save' }.to change { UserStory.count }.by 1
    end
  end
end
