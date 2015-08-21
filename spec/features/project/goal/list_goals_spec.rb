require 'spec_helper'

feature 'List goals' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let!(:goal_a)     { create :goal, title: 'Make Love', hypothesis: hypothesis }
  let!(:goal_b)     { create :goal, title: 'Not War', hypothesis: hypothesis }

  background do
    sign_in user
    visit project_hypotheses_path project
  end

  scenario 'should list all goals for a hypothesis' do
    within '.hypothesis .content .goals' do
      expect(page).to have_content 'Make Love'
      expect(page).to have_content 'Not War'
    end
  end
end
