require 'spec_helper'

feature 'List user stories' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }

  background do
    create(
      :user_story,
      project:    project,
      hypothesis: hypothesis,
      role:       'User',
      action:     'login',
      result:     'enjoy'
    )
    create(
      :user_story,
      project:    project,
      hypothesis: hypothesis,
      role:       'Admin',
      action:     'administrate',
      result:     'do work'
    )
    sign_in user
  end

  scenario 'should list all user_stories for a hypothesis on lab section.' do
    visit project_hypotheses_path project
    UserStory.all.each do |user_story|
      within "#edit_user_story_#{user_story.id}" do
        expect(find('#user_story_role').value).to have_text user_story.role
        expect(find('#user_story_action').value).to have_text user_story.action
        expect(find('#user_story_result').value).to have_text user_story.result
      end
    end
  end

  scenario 'should list all user_stories for a hypothesis on backlog section.',
    js: true do
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

  scenario 'should show an edit link for each user_story' do
    visit project_hypotheses_path project
    within '.hypothesis .content .user-story-list' do
      UserStory.all.each do |user_story|
        expect(page).to have_css "#edit_user_story_#{user_story.id}"
      end
    end
  end

  scenario 'should not show user stories who does not belongs to an hypothesis
    on lab section', js: true do
    user_story = create :user_story, project: project, hypothesis: nil
    visit project_hypotheses_path project
    expect(page).not_to have_css "li.user-story[data-id='#{user_story.id}']"
  end

  scenario 'should show user story who does not belongs to an hypothesis on
    backlog section', js: true do
    user_story = create :user_story, project: project, hypothesis: nil
    visit project_user_stories_path project
    expect(page).to have_css "li.user-story[data-id='#{user_story.id}']"
  end
end
