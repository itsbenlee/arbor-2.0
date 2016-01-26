require 'spec_helper'

feature 'Index Teams' do
  let!(:user)  { create :user }
  let!(:teams) { create_list :team, 3, users: [user] }

  background do
    sign_in user
    visit arbor_reloaded_teams_path
  end

  scenario "it should list the user's teams" do
    within '.section-people' do
      teams.each do |team|
        expect(page).to have_content(team.name)
        expect(page).to have_text("#{team.users.count} member")
      end
    end
  end
end
