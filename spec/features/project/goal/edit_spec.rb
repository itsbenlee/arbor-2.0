require 'spec_helper'

feature 'Edit an existing goal' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let!(:goal)       { create :goal, hypothesis: hypothesis }

  background do
    sign_in user
    visit project_hypotheses_path project
  end

  scenario 'should show me a edit form once clicking a goal item' do
    within 'div.goals' do
      find('.goal-item').click
      expect(page).to have_css '.goal-item-editable form'
    end
  end

  scenario 'should show me an edit form when I follow the edit link' do
    within 'div.goals' do
      find('.goal-item').click
      expect(page).to have_field :goal_title
    end
  end

  scenario 'should update the goal when I submit the edit form' do
    updated_title = 'New goal title'

    within 'div.goals' do
      find('.goal-item').click
    end

    within '.goal-item-editable form' do
      fill_in :goal_title, with: updated_title
      click_button :save
    end

    expect(page).to have_content updated_title

    goal.reload
    expect(goal.title).to eq updated_title
  end
end
