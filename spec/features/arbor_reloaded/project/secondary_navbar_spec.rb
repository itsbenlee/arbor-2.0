require 'spec_helper'

feature 'secondary navbar' do
  let(:user)    { create :user }
  let(:project) { create :project, owner: user }
  subject { page }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project.id)
  end

  context 'release plan link is present' do
    scenario { should have_selector(:link_or_button, 'Release plan') }
  end

  context 'release plan link works' do
    background do
      click_link 'Release plan'
    end

    scenario { should have_current_path release_plan_arbor_reloaded_project_path(project)  }
  end
end
