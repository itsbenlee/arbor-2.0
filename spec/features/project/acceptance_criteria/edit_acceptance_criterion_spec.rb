require 'spec_helper'

feature 'Update an acceptance criterion' do
  let!(:user)                 { create :user }
  let!(:project)              { create :project, owner: user }
  let!(:user_story)           { create :user_story, project: project }
  let!(:acceptance_criterion) do
    create :acceptance_criterion, user_story: user_story
  end

  background do
    sign_in user
    visit project_user_stories_path project
    find('.user-story').click
  end

  scenario 'should show me an acceptance criterion edit form', js: true do
    expect(page).to have_css 'form.edit_acceptance_criterion'
    within 'form.edit_acceptance_criterion' do
      expect(page).to have_field :acceptance_criterion_description
    end
  end

  scenario 'should update an acceptance criterion', js: true do
    pending 'Need to fix javascript/database cleaner/shared connection'

    within 'form.edit_acceptance_criterion' do
      fill_in :acceptance_criterion_description, with: 'new description'
      find('input#save-acceptance-criterion', visible: false).trigger('click')
    end
    expect(AcceptanceCriterion.first.description).to eq 'new description'
  end
end
