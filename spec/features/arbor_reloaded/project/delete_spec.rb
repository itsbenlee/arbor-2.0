require 'spec_helper'

feature 'delete project' do
  let!(:user)     { create :user }
  let!(:user2)    { create :user }
  let!(:project)  { create :project, owner: user }

  context 'when the user is owner' do
    background do
      sign_in user
      visit arbor_reloaded_project_user_stories_path project
    end

    scenario 'should show me the delete link' do
      expect(page).to have_css('.icn-delete')
    end

    context 'when deleting project', js: true do
      background do
        click_link 'More...'
        click_link 'Delete project'
      end

      scenario 'should display delete modal' do
        expect(page).to have_selector('#delete-modal', visible: true)
      end

      scenario 'should dismiss modal when clicking on cancel button' do
        within '#delete-modal' do
          click_link 'Cancel, do not delete'
        end

        expect(page).to have_selector('#delete-modal', visible: false)
      end

      scenario 'should delete project when click on confirm button' do
        within '#delete-modal' do
          click_link 'Yes, delete project'
        end

        expect(Project.find_by(id: project.id)).to be nil
      end
    end
  end

  context 'when the user is not owner' do
    background do
      project.members << user2
      sign_in user2
      visit arbor_reloaded_project_user_stories_path(project.id)
    end

    scenario 'should not show me the delete link' do
      expect(page).not_to have_css('.delete-project')
    end
  end
end
