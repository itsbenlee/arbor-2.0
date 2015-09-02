require 'spec_helper'

feature 'Create a new epic' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let(:epic)        { build :epic }

  background do
    sign_in user
  end

  scenario 'should show me an epic creation form for each hypothesis on lab section' do
    visit project_hypotheses_path project
    expect(page).to have_css 'form.new_user_story'
    %w(user_story_role user_story_action user_story_result).each do |input|
      expect(page).to have_field input
    end
  end

  scenario 'should create a new epic on lab section' do
    visit project_hypotheses_path project
    within 'form.new_user_story' do
      fill_in :user_story_role, with: epic.role
      fill_in :user_story_action, with: epic.action
      fill_in :user_story_result, with: epic.result

      expect{ click_button 'Save' }.to change{ UserStory.count }.from(0).to(1)
    end
  end

  scenario 'should show me an epic creation form for each hypothesis on backlog section' do
    visit project_user_stories_path project
    expect(page).to have_css 'form.new_user_story'
    %w(user_story_role user_story_action user_story_result).each do |input|
      expect(page).to have_field input
    end
  end

  scenario 'should create a new epic on backlog section' do
    visit project_user_stories_path project
    within 'form.new_user_story' do
      fill_in :user_story_role, with: epic.role
      fill_in :user_story_action, with: epic.action
      fill_in :user_story_result, with: epic.result

      expect{ click_button 'Save' }.to change{ UserStory.count }.from(0).to(1)
    end
  end
end
