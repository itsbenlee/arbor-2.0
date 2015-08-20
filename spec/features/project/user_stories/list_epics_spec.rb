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
    within '.hypothesis .content table' do
      expect(page).to have_content 'User'
      expect(page).to have_content 'login'
      expect(page).to have_content 'enjoy'

      expect(page).to have_content 'Admin'
      expect(page).to have_content 'administrate'
      expect(page).to have_content 'do work'
    end
  end

  scenario 'should show an edit link for each epic' do
    within '.hypothesis .content table' do
      UserStory.all.each do |epic|
        expect(page).to have_href edit_project_user_story_path(project, epic)
      end
    end
  end
end
