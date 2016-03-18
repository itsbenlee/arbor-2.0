require 'spec_helper'

feature 'delete members on modal', js: true do
  let!(:user)     { create :user }
  let!(:user2)    { create :user }
  let!(:project)  { create :project, owner: user, members: [user, user2] }

  context 'when the user is on backlog' do
    background do
      sign_in user
      visit arbor_reloaded_project_user_stories_path(project_id:project.id)
      page.evaluate_script('$.fx.off = true;')
      find('a.add-member').trigger('click')
    end

    scenario 'should show me the remove button when clicking the checkbox' do
      within '.project-members' do
        find('.remove-member-check').trigger('click')
      end

      within '.modal-footer' do
        expect(page).to have_css('#people-modal-footer-btn', visible: false)
      end
    end

    scenario 'should remove a member from the project and nav_bar' do
      expect(project.members.count).to eq(2)
      within '.members-avatars' do
        expect(page).to have_selector('.avatar-img', count: 2)
      end

      within '.project-members' do
        find('.remove-member-check').trigger('click')
      end
      find('#people-modal-footer-btn').trigger('click')
      sleep 0.5
      within '.members-avatars' do
        expect(page).to have_selector('.avatar-img', count: 1)
      end
      expect(project.members.count).to eq(1)
    end
  end
end
