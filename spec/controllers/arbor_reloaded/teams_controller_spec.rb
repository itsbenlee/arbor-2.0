require 'spec_helper'

RSpec.describe ArborReloaded::TeamsController do
  let(:user)         { create :user }
  let(:team)         { create :team }
  let(:another_user) { create :user }

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

  describe 'Add member' do
    it 'should add a member' do
      put(
        :add_member,
        team_id: team.id,
        format: :js,
        member: another_user.email,
      )

      team.reload
      expect{ team.users.count }.to become_eq 2
      expect(team.users.last).to eq(another_user)
    end
  end

  describe 'Remove member' do
    let(:team2) { create :team }

    before :each do
      team2.users << another_user
      team2.reload
    end

    it 'should remove a member' do
      put(
        :remove_member,
        team_id: team2.id,
        format: :js,
        member: another_user.id,
      )

      team2.reload
      expect{ team2.users.count }.to become_eq 1
      expect(team2.users.include? another_user).to eq(false)
    end
  end
end
