require 'spec_helper'

feature 'List epics' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }

  background do
    create(
      :epic,
      project:    project,
      hypothesis: hypothesis,
      role:       'User',
      action:     'login',
      result:     'enjoy'
    )
    create(
      :epic,
      project:    project,
      hypothesis: hypothesis,
      role:       'Admin',
      action:     'administrate',
      result:     'do work'
    )

    sign_in user
    visit project_hypotheses_path project
  end

  scenario 'should list all epics for a hypothesis' do
    UserStory.all.each do |epic|
      within "#edit_user_story_#{epic.id}" do
        expect(find('#user_story_role').value).to have_text epic.role
        expect(find('#user_story_action').value).to have_text epic.action
        expect(find('#user_story_result').value).to have_text epic.result
      end
    end
  end

  scenario 'should show an edit link for each epic' do
    within '.hypothesis .content .user-story-list' do
      UserStory.all.each do |epic|
        expect(page).to have_css "#edit_user_story_#{epic.id}"
      end
    end
  end
end
