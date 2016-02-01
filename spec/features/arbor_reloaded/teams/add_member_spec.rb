require 'spec_helper'

feature 'Add a member', js: true do
  let!(:user)         { create :user }
  let!(:another_user) { create :user }
  let!(:team)         { create :team }

  background do
    sign_in user
    visit arbor_reloaded_teams_path
  end

  scenario 'should be able add a member to a team' do
    find('#new-team-button').trigger('click')
    within 'form.new_team' do
      fill_in(:team_name, with: 'Test team')
      find('input#save-team').trigger('click')
    end

    find('.team').trigger('click')
    find('.new-member-mail').set(another_user.email)
    find('#team-modal-footer-btn').trigger('click')

    within '.section-people' do
      expect(page).to have_content 'Test team'
      expect(page).to have_content '2 members'
    end
  end
end
