require 'spec_helper'

feature 'Add member to team', js: true do
  let!(:user) { create :user }
  let!(:team) { create :team, owner: user }

  background do
    sign_in user
    visit arbor_reloaded_teams_path

    within 'ul.teams-list' do
      find('li.team.white-block').click
    end
  end

  context 'for an existent user' do
    let!(:other_user) { create :user }

    background do
      fill_in :member, with: other_user.email
      click_link 'Invite'
      wait_for_ajax
    end

    scenario 'should add user as team member' do
      expect(team.users.reload.count).to eq(2)
    end

    scenario 'team users should include added email' do
      expect(team.users.reload.include?(other_user)).to eq(true)
    end
  end

  context 'for a new user' do
    let!(:new_user_email) { Time.now.to_i.to_s + Faker::Internet.email }

    background do
      fill_in :member, with: new_user_email
      click_link 'Invite'
      wait_for_ajax
    end

    scenario 'should create an invite for user with the right email' do
      invite_for_user = Invite.for_teams(new_user_email).first
      expect(invite_for_user.email).to eq(new_user_email)
    end

    scenario 'should create an invite for user with the right team id' do
      invite_for_user = Invite.for_teams(new_user_email).first
      expect(invite_for_user.team_id).to eq(team.id)
    end

    scenario 'after sign up the user is part of the team' do
      sign_out
      sign_up(new_user_email)

      visit arbor_reloaded_teams_path

      expect(page).to have_content(team.name)
    end
  end
end
