require 'spec_helper'

feature 'Edit an existing goal' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let!(:goal)       { create :goal, hypothesis: hypothesis }
  let(:other_goal)  { build :goal }

  background do
    sign_in user
    visit project_hypotheses_path project
  end

  scenario 'should show me an edit link for the goal' do
    within 'div.goals' do
      expect(page).to have_href edit_goal_path(goal)
      expect(page).to have_content 'Edit'
    end
  end

  scenario 'should show me an edit form when I follow the edit link' do
    within 'div.goals' do
      click_link 'Edit'
    end

    expect(page).to have_field :goal_title
  end

  scenario 'should update the goal when I submit the edit form' do
    within 'div.goals' do
      click_link 'Edit'
    end

    fill_in :goal_title, with: other_goal.title
    click_button 'Save'

    expect(page).to have_content other_goal.title

    goal.reload
    expect(goal.title).to eq other_goal.title
  end
end
