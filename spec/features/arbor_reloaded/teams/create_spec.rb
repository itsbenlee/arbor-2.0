require 'spec_helper'

feature 'Create a new team', js: true do
  let!(:user) { create :user }

  background do
    sign_in user
    visit arbor_reloaded_teams_path
  end

  scenario 'should display a new team link' do
    expect(page).to have_css '#new-team-button'
  end

  scenario 'should successfully save a team with a valid team name' do
    find('#new-team-button').trigger('click')
    within 'form.new_team' do
      fill_in(:team_name, with: 'Test team')
      find('input#save-team').trigger('click')
    end

    expect{ Team.count }.to become_eq 1
    within '.section-people' do
      expect(page).to have_content 'Test team'
    end
  end
end
