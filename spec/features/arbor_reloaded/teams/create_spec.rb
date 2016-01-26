require 'spec_helper'

feature 'Create a new team', js: true do
  let!(:user) { create :user }

  background do
    sign_in user
    visit arbor_reloaded_team_path
  end

  scenario 'should display a new team link' do
    expect(page).to have_css '.new-team'
  end

  scenario 'should successfully save a team with a valid team name' do
    find('.new-team').click
    fill_in 'team_name', with: 'Test team'
    find('.create_team').click

    expect(page).to have_content 'Test Project'
    expect(Team.first.name).to eq 'Test Project'
  end
end
