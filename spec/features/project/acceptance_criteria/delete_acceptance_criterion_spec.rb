require 'spec_helper'

feature 'Delete an acceptance criterion' do
  let!(:user)                 { create :user }
  let!(:project)              { create :project, owner: user }
  let!(:user_story)           { create :user_story, project: project }
  let!(:acceptance_criterion) {
    create :acceptance_criterion,
    user_story: user_story
  }

  background do
    sign_in user
    visit project_user_stories_path project
    find('.user-story').click
  end

  scenario 'should show me a delete link', js: true do
    within '.delete-acceptance-criterion-edit' do
      expect(page).to have_selector 'a#delete_acceptance_criterion'
    end
  end

  scenario 'should delete an acceptance_criterion successfully', js: true do
    within '.delete-acceptance-criterion-edit' do
      find('a#delete_acceptance_criterion').trigger('click')
    end

    expect{ AcceptanceCriterion.exists? acceptance_criterion.id }.to become_eq false
  end

  scenario 'should remove the acceptance_criterion from the form', js: true do
    within '.delete-acceptance-criterion-edit' do
      find('a#delete_acceptance_criterion').trigger('click')
    end

    expect(page).not_to have_selector('.delete-acceptance-criterion-edit')
  end
end
