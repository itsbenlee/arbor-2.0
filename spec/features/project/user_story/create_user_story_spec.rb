require 'spec_helper'

feature 'Create a new user story' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let(:user_story)  { build :user_story }

  background do
    sign_in user
  end

  scenario 'should show me an user story creation form for each hypothesis on
    lab section' do
    visit project_hypotheses_path project
    expect(page).to have_css 'form.new_user_story'
    %w(user_story_role user_story_action user_story_result).each do |input|
      expect(page).to have_field input
    end
  end

  scenario 'should create a new user story on lab section' do
    visit project_hypotheses_path project
    within 'form.new_user_story' do
      fill_in :user_story_role, with: user_story.role
      fill_in :user_story_action, with: user_story.action
      fill_in :user_story_result, with: user_story.result

      expect{ click_button 'Save' }.to change{ UserStory.count }.from(0).to(1)
    end
  end

  scenario 'should show me an user story creation form for each hypothesis on
    backlog section' do
    visit project_user_stories_path project
    expect(page).to have_css 'form.new_user_story'
    %w(user_story_role user_story_action user_story_result).each do |input|
      expect(page).to have_field input
    end
  end

  scenario 'should create a new user story on backlog section' do
    visit project_user_stories_path project
    within 'form.new_user_story' do
      fill_in :user_story_role, with: user_story.role
      fill_in :user_story_action, with: user_story.action
      fill_in :user_story_result, with: user_story.result

      expect{ click_button 'Save' }.to change{ UserStory.count }.from(0).to(1)
    end
  end

  scenario 'should create a new user story as a non epic' do
    visit project_user_stories_path project
    within 'form.new_user_story' do
      fill_in :user_story_role, with: user_story.role
      fill_in :user_story_action, with: user_story.action
      fill_in :user_story_result, with: user_story.result

      click_button 'Save'
    end

    expect(UserStory.first.epic).to be false
  end

  scenario 'should create a new user story as a an epic' do
    visit project_user_stories_path project
    within 'form.new_user_story' do
      fill_in :user_story_role, with: user_story.role
      fill_in :user_story_action, with: user_story.action
      fill_in :user_story_result, with: user_story.result
      check :user_story_epic

      click_button 'Save'
    end

    expect(UserStory.first.epic).to be true
  end
end
