require 'spec_helper'

feature 'Create a new user story' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let(:user_story)  { build :user_story }

  background do
    sign_in user
  end

  context 'lab section' do
    background do
      visit project_hypotheses_path project
    end

    scenario 'should show me an user story creation form for each hypothesis' do
      expect(page).to have_css 'form.new_user_story'
      %w(user_story_role user_story_action user_story_result).each do |input|
        expect(page).to have_field input
      end
    end

    scenario 'should create a new user story' do
      within 'form.new_user_story' do
        fill_in :user_story_role, with: user_story.role
        fill_in :user_story_action, with: user_story.action
        fill_in :user_story_result, with: user_story.result

        expect{ click_button 'Save' }.to change{ UserStory.count }.from(0).to(1)
      end
    end
  end

  context 'backlog section' do
    background do
      visit project_user_stories_path project
    end

    scenario 'should show me an user story creation form for each hypothesis on
      backlog section' do
      expect(page).to have_css 'form.new_user_story'
      %w(user_story_role user_story_action user_story_result).each do |input|
        expect(page).to have_field input
      end
    end

    scenario 'should create a new user story on backlog section' do
      within 'form.new_user_story' do
        fill_in :user_story_role, with: user_story.role
        fill_in :user_story_action, with: user_story.action
        fill_in :user_story_result, with: user_story.result

        expect{ click_button 'Save' }.to change{ UserStory.count }.from(0).to(1)
      end
    end

    scenario 'should show on lab user stories created on backlog' do
      within 'form.new_user_story' do
        fill_in :user_story_role, with: user_story.role
        fill_in :user_story_action, with: user_story.action
        fill_in :user_story_result, with: user_story.result

        click_button 'Save'
      end

      visit project_hypotheses_path project
      expect(page).to have_css 'section#user-stories-without-hypothesis'

      within 'section#user-stories-without-hypothesis form' do
        expect(find('#user_story_role').value).to have_text user_story.role
        expect(find('#user_story_action').value).to have_text user_story.action
        expect(find('#user_story_result').value).to have_text user_story.result
      end
    end

    scenario 'should create a new user story as a non epic' do
      within 'form.new_user_story' do
        fill_in :user_story_role, with: user_story.role
        fill_in :user_story_action, with: user_story.action
        fill_in :user_story_result, with: user_story.result

        click_button 'Save'
      end

      expect(UserStory.first.epic).to be false
    end

    scenario 'should create a new user story as a an epic' do
      within 'form.new_user_story' do
        fill_in :user_story_role, with: user_story.role
        fill_in :user_story_action, with: user_story.action
        fill_in :user_story_result, with: user_story.result
        check :user_story_epic

        click_button 'Save'
      end

      expect(UserStory.first.epic).to be true
    end

    scenario 'should create a new user story with another priority' do
      within 'form.new_user_story' do
        fill_in :user_story_role, with: user_story.role
        fill_in :user_story_action, with: user_story.action
        fill_in :user_story_result, with: user_story.result
        select 'must', from: :user_story_priority

        click_button 'Save'
      end

      expect(UserStory.first.priority).to eq 'must'
    end

    scenario 'should change the priority field in the story text', js: true do
      priority_field = find('.user-story-priority')
      expect(priority_field.text).to eq 'should'

      select 'must', from: :user_story_priority

      expect(priority_field.text).to eq 'must'
    end

    scenario 'should create a new user story with an estimation' do
      within 'form.new_user_story' do
        fill_in :user_story_role, with: user_story.role
        fill_in :user_story_action, with: user_story.action
        fill_in :user_story_result, with: user_story.result
        select user_story.estimated_points, from: :user_story_estimated_points

        click_button 'Save'
      end

      expect(UserStory.first.estimated_points).to eq 2
    end

    scenario 'should create a new user story without an estimation' do
      within 'form.new_user_story' do
        fill_in :user_story_role, with: user_story.role
        fill_in :user_story_action, with: user_story.action
        fill_in :user_story_result, with: user_story.result

        click_button 'Save'
      end

      expect(UserStory.first.estimated_points).to be_nil
    end
  end
end
