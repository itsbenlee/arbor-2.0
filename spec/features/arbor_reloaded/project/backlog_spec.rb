require 'spec_helper'

def set_project_cost(project_cost)
  within '#estimation-item-cost' do
    find('.icn-settings', visible: false).trigger(:click)
    sleep 0.5
  end

  find('#project_cost_per_week').set(project_cost)
  click_button 'Save Changes'
  wait_for_ajax
end

feature 'Project backlog', js: true do
  let!(:user)         { create :user }
  let!(:project)      { create :project, owner: user }
  let!(:user_stories) { create_list :user_story, 3, project: project }

  context 'for updating costs' do
    background do
      sign_in user
      visit arbor_reloaded_project_user_stories_path(project.id)
    end

    scenario 'the cost is updated on database' do
      set_project_cost(10)
      expect(project.reload.cost_per_week).to eq(10)
    end

    scenario 'the cost is updated on database when is a big amount' do
      big_amount = 999999999999999
      set_project_cost(big_amount)
      expect(project.reload.cost_per_week).to eq(big_amount)
    end
  end
end
