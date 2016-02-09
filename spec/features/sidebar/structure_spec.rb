require 'spec_helper'

feature 'Sidebar structure changes' do
  context 'for a not logged user' do
    scenario 'the sidebar is no displayed' do
      visit new_user_session_path
      expect(page).not_to have_css('aside#sidebar')
    end
  end

  context 'for a logged user', js: true do
    let!(:user)       { create :user }
    let!(:project)    { create :project, owner: user }

    background do
      sign_in user
      visit projects_path
    end

    scenario 'the sidebar is displayed' do
      expect(page).to have_css('aside#sidebar')
    end

    scenario 'the workspace section is not displayed if the user no select a project' , js: true do
      expect(page).not_to have_css('ul#workspace')
    end

    scenario 'the links to canvas backlog and lab are not displayed if the user no select a project' do
      expect(page).not_to have_css('a.canvas')
      expect(page).not_to have_css('a.lab')
      expect(page).not_to have_css('a.backlog')
    end

    scenario 'the workspace section is displayed when a project is selected' do
      find('a.sidebar-project-item').click
      expect(page).to have_css('ul#workspace')
    end

    scenario 'the canvas link works' do
      find('a.sidebar-project-item').click
      within 'ul#workspace' do
        find('a.canvas').click
      end
      expect(page).to have_css 'section#canvas'
    end

    scenario 'should display a link to the files section' do
      find('a.sidebar-project-item').click
      within 'ul#extras' do
        expect(page).to have_link 'Files'
      end
    end

    scenario 'the lab link works' do
      find('a.sidebar-project-item').click
      within 'ul#workspace' do
        find('a.lab').click
      end
      expect(page).to have_css 'section#hypotheses'
    end

    scenario 'the backlog link works' do
      find('a.sidebar-project-item').click
      within 'ul#workspace' do
        find('a.backlog').click
      end
      expect(page).to have_css 'section.backlog'
    end
  end
end
