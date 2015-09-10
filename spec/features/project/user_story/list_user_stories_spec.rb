require 'spec_helper'

feature 'List user stories' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }

  background do
    create(
      :user_story,
      project:          project,
      hypothesis:       hypothesis,
      role:             'User',
      action:           'login',
      result:           'enjoy',
      estimated_points: 1
    )
    create(
      :user_story,
      project:          project,
      hypothesis:       hypothesis,
      role:             'Admin',
      action:           'administrate',
      result:           'do work',
      estimated_points: 2,
      priority:         'could'
    )
    sign_in user
  end

  context 'lab section' do
    scenario 'should list all user_stories for a hypothesis' do
      visit project_hypotheses_path project
      UserStory.all.each do |user_story|
        within "#edit_user_story_#{user_story.id}" do
          expect(find('#user_story_role').value).to have_text user_story.role
          expect(find('#user_story_action').value).to have_text user_story.action
          expect(find('#user_story_result').value).to have_text user_story.result
        end
      end
    end

    scenario 'should not show user stories which does not belongs to a
      hypothesis', js: true do
      user_story = create :user_story, project: project, hypothesis: nil
      visit project_hypotheses_path project
      expect(page).not_to have_css "li.user-story[data-id='#{user_story.id}']"
    end

    scenario 'should show an edit link for each user_story' do
      visit project_hypotheses_path project
      within '.hypothesis .content .user-story-list' do
        UserStory.all.each do |user_story|
          expect(page).to have_css "#edit_user_story_#{user_story.id}"
        end
      end
    end
  end

  context 'backlog section' do
    scenario 'should list all user_stories for a hypothesis', js: true do
      visit project_user_stories_path project
      UserStory.all.each do |user_story|
        within "li.user-story[data-id='#{user_story.id}']" do
          expect(page).to have_text user_story.role
          expect(page).to have_text user_story.action
          expect(page).to have_text user_story.result
          expect(page).to have_text user_story.story_number
        end
      end
    end

    scenario 'should show user story which does not belongs to a hypothesis',
      js: true do
      user_story = create :user_story, project: project, hypothesis: nil
      visit project_user_stories_path project
      expect(page).to have_css "li.user-story[data-id='#{user_story.id}']"
    end

    scenario 'should show the default priority' do
      visit project_user_stories_path project

      within ".user-story[data-id='#{UserStory.first.id}'] .story-text" do
        expect(page).to have_content 'should'
      end
    end

    scenario 'should show changed priority' do
      visit project_user_stories_path project

      within ".user-story[data-id='#{UserStory.second.id}'] .story-text" do
        expect(page).to have_content 'could'
        expect(page).not_to have_content 'should'
      end
    end

    scenario 'should show estimation text for 1 point story' do
      visit project_user_stories_path project

      within ".user-story[data-id='#{UserStory.first.id}'] .points" do
        expect(page).to have_content "1 point"
      end
    end

    scenario 'should show estimation text for 2 points story' do
      visit project_user_stories_path project

      within ".user-story[data-id='#{UserStory.second.id}'] .points" do
        expect(page).to have_content "2 points"
      end
    end

    scenario 'should not show any estimation text for no estimation' do
      UserStory.first.update_attribute(:estimated_points, nil)
      visit project_user_stories_path project

      points_field = find ".user-story[data-id='#{UserStory.first.id}'] .points"
      expect(points_field.text).to be_empty
    end
  end
end
