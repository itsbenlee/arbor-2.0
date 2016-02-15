require 'spec_helper'

feature 'Delete team', js: true do
  let!(:user) { create :user }
  let!(:user2) { create :user }
  let!(:team) { create :team, name: 'Awesome team', owner: user}

  background do
    sign_in user
    team.users << user2
    visit arbor_reloaded_teams_path
  end

  scenario 'should delete team' do
    find(".others").trigger(:click)

    within '.actions' do
      find('a.delete-project').click
    end

    within '.deleter' do
      find('a.tiny').click
    end

    visit arbor_reloaded_teams_path
    expect(page).to_not have_content('Awesome team')
  end
end
