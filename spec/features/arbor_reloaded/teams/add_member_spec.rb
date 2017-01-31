require 'spec_helper'

feature 'Add member to team', skip: true, js: true do
  let!(:user)  { create :user }
  let!(:user2) { create :user }
  let!(:team)  { create :team, owner: user, users: [user, user2] }

  background do
    sign_in user
    visit arbor_reloaded_teams_path

    within 'ul.teams-list' do
      find('li.team.white-block').click
    end
  end

  context 'Checking button behaivor' do
    let!(:other_user) { create :user }

    scenario 'I should see the close button' do
      within '.modal-footer' do
        expect(page).to have_content('Close')
      end
    end

    scenario 'When typing user I should see invite button' do
      fill_in :member, with: other_user.email

      within '.modal-footer' do
        expect(page).to have_content('Invite')
      end
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
      expect(team.users.reload.count).to eq(3)
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

  context 'Deleting member' do
    scenario 'should show me the remove button when clicking the checkbox' do
      within '.team-members-list' do
        find('.remove-member-check').trigger('click')
      end

      within '.modal-footer' do
        expect(find('.team-members-button')).to have_content('Remove')
      end
    end

    scenario 'should remove a member from the team' do
      expect(team.users.count).to eq(2)

      within '.team-members-list' do
        find('.remove-member-check').trigger('click')
      end
      find('.team-members-button').trigger('click')
      sleep 0.5

      expect(team.users.count).to eq(1)
    end
  end
end
