require 'spec_helper'

RSpec.describe ArborReloaded::TeamsController do
  let(:user)         { create :user }
  let(:team)         { create :team, owner: user }
  let(:another_user) { create :user }

  context 'when the user is signed in' do
    before :each do
      sign_in user
    end

    describe 'POST create' do
      it 'should create a new team' do
        post(
          :create,
          format: :js,
          team: { name: 'Team name' }
        )

        expect{ Team.count }.to become_eq 1
        created_team = Team.last
        expect(created_team.users).to eq([user])
        expect(created_team.owner).to eq(user)
        expect(created_team.name).to eq('Team name')
      end
    end

    describe 'DELETE destroy' do
      let!(:project) { create :project, team: team, owner: user }

      context 'if the signed user is not the owner' do
        it 'should not destroy the team' do
          sign_in create :user
          request.env['HTTP_REFERER'] = arbor_reloaded_teams_path

          post(:destroy, id: team.id)

          expect(response).to be_not_found
          expect(Team.find(team.id)).to be_present
        end
      end

      it 'should destroy a team and not the projects' do
        request.env['HTTP_REFERER'] = arbor_reloaded_teams_path

        post(:destroy, id: team.id)

        expect{ Team.find(team.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(project.owner).to eq(user)
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
        expect{ team.users.reload.count }.to become_eq 2
        expect(team.users).to include(another_user)
      end

      context 'if the signed user is not the owner' do
        it 'should not add a member' do
          sign_in create :user
          put(
            :add_member,
            team_id: team.id,
            format: :js,
            member: another_user.email,
          )
          expect(response).to be_not_found
          team.reload
          expect(team.users.reload.count).to eq(1)
          expect(team.users).not_to include(another_user)
        end
      end
    end

    describe 'Remove member' do
      let(:team2) { create :team, owner: user }

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

      context 'if the signed user is not the owner' do
        it 'should not remove a member' do
          sign_in create :user
          put(
            :remove_member,
            team_id: team2.id,
            format: :js,
            member: another_user.id,
          )

          expect(response).to be_not_found

          team2.reload
          expect(team2.users).to match_array([user, another_user])
        end
      end
    end
  end

  context 'when the user is not signed in' do
    describe 'POST create' do
      it 'should not create a team' do
        post(
          :create,
          format: :js,
          team: { name: 'Team name' }
        )

        expect(response).to be_unauthorized
      end
    end
  end
end
