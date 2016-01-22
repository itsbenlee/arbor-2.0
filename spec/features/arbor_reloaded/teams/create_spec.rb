require 'spec_helper'

feature 'Create Team' do
  let!(:user) { create :user }
  let!(:team) { create :team }

  scenario 'it should assign user to team' do
    user.teams << team

    expect(user.teams.first).to eq(team)
    expect(team.users.first).to eq(user)
  end
end
