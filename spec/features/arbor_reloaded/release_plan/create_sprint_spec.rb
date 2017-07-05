require 'spec_helper'

feature 'create sprint from release plan page' do
  let(:user)    { create :user }
  let(:project) { create :project, owner: user }

  background do
    sign_in user
    visit release_plan_arbor_reloaded_project_path(project.id)
  end

  context 'check page structure' do
    subject { page }

    it { should have_selector :link_or_button, '+ Sprint' }
  end

  context '+ Sprint button works' do
    background do
      click_link '+ Sprint'
      wait_for_ajax
    end

    it 'should add a sprint into project if you click the + Sprint button', js: true do
      expect(project.sprints.reload.count).to eq 6
    end

    it 'should add show the sprint added if you click the + Sprint button', js: true do
      expect(page).to have_selector('th.sprint-title', count: 6)
    end
  end
end
