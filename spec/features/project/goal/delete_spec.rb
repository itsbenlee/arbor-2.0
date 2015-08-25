require 'spec_helper'

feature 'Delete an existing goal' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let!(:goal)       { create :goal, hypothesis: hypothesis }

  background do
    sign_in user
    visit project_hypotheses_path project
  end

  scenario 'should show me a delete link for the goal' do
    within 'div.goals' do
      expect(page).to have_href goal_path(goal)
      expect(page).to have_content 'Delete'
    end
  end

  scenario 'should delete the goal when I click the link' do
    within 'div.goals' do
      expect{ click_link 'Delete' }.to change{ Goal.count }.from(1).to(0)
    end

    expect(page).not_to have_content goal.title
  end
end
