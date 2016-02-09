require 'spec_helper'

feature 'Index projects' do
  let!(:user) { create :user }

  background do
    sign_in user
  end

  context 'when they belong to teams' do
    let(:team)     { create :team }
    let!(:project) { create :project, team: team }

    background do
      user.teams << team
      visit arbor_reloaded_root_path
    end

    scenario 'it should show a join button' do
      within '.team-projects-list' do
        expect(page).to have_text(project.name)
        expect(page).to have_css('.join-btn')
      end
    end

    scenario 'should not be member of the team projects' do
      expect(project.members.include? user).to be(false)
    end

    scenario 'should become member when clicking the button' do
      within '.team-projects-list' do
        find('.join-btn').click
      end
      project.reload
      expect(project.members.include? user).to be(true)
    end
  end
end
