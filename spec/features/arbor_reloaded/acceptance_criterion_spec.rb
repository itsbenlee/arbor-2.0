require 'spec_helper'

feature 'Acceptance criterions', js:true do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }
  let!(:criterion)  { create :acceptance_criterion, user_story: user_story }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
    find('.story-detail-link').trigger('click')
  end

  scenario 'should be able to delete a criterion' do
    within '#story-detail-modal' do
      find('.criterion').trigger('click')
      find('.icn-delete').trigger('click')
    end
    wait_for_ajax
    expect(AcceptanceCriterion.count).to eq 0
  end
end
