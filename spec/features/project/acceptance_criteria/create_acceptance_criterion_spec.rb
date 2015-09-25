require 'spec_helper'

feature 'Create a new acceptance criterion' do
  let!(:user)                 { create :user }
  let!(:project)              { create :project, owner: user }
  let!(:user_story)           { create :user_story, project: project }
  let(:acceptance_criterion)  { build :acceptance_criterion }

  background do
    sign_in user
    visit project_user_stories_path project
    find('.user-story').click
  end

  scenario 'should show me an acceptance criterion creation form', js: true do
    expect(page).to have_css 'form.new_acceptance_criterion'
    within 'form.new_acceptance_criterion' do
      expect(page).to have_field :acceptance_criterion_description
    end
  end

  scenario 'should create a new acceptance criterion', js: true do
    pending 'Need to fix javascript/database cleaner/shared connection'

    within 'form.new_acceptance_criterion' do
      fill_in(
        :acceptance_criterion_description,
        with: acceptance_criterion.description
      )
      find('input#save-acceptance-criterion', visible: false).trigger('click')
    end
    expect(AcceptanceCriterion.count).to eq 1
  end
end
