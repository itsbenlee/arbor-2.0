require 'spec_helper'

def set_project_cost(project_cost)
  set_cost_input do
    find('#project_cost_per_week').set(project_cost)
  end
end

def set_project_velocity(velocity)
  set_cost_input do
    find('#project_velocity').set(velocity)
  end
end

def set_cost_input
  within '#estimation-item-cost' do
    find('.icn-settings', visible: false).trigger(:click)
    sleep 0.5
  end

  yield
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

    scenario 'the cost is updated on database when is zero' do
      set_project_cost(0)
      expect(project.reload.cost_per_week).to eq(0)
    end

    scenario 'the velocity is updated on database when is possitive' do
      set_project_velocity(1)
      expect(project.reload.velocity).to eq(1)
    end

    scenario 'the velocity is updated on database when is zero' do
      set_project_velocity(0)
      expect(project.reload.velocity).to eq(0)
    end

    scenario 'the velocity is not updated on database when is negative' do
      set_project_velocity(-1)
      expect(project.reload.velocity).to be(nil)
    end
  end
end
