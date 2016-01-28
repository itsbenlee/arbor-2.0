require 'spec_helper'

RSpec.describe ArborReloaded::TeamsController do
  let(:user) { create :user }

  before :each do
    sign_in user
  end

  describe 'POST create' do
    it 'should create a new team' do
      post(
        :create,
        format: :js,
        team: { name: 'Team name' },
        owner: user,
      )

      expect{ Team.count }.to become_eq 1
      created_team = Team.last
      expect(created_team.users).to eq([user])
      expect(created_team.owner).to eq(user)
      expect(created_team.name).to eq('Team name')
    end
  end
end
