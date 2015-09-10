require 'spec_helper'

feature 'Create a new constraint' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }
  let(:constraint)  { build :constraint }

  background do
    sign_in user
    visit project_user_stories_path project
    find('.user-story').click
  end

  scenario 'should show me a constraint creation form', js: true do
    expect(page).to have_css 'form.new_constraint'
    within 'form.new_constraint' do
      expect(page).to have_field :constraint_description
    end
  end

  scenario 'should create a new constraint', js: true do
    pending 'Need to fix javascript/database cleaner/shared connection'

    within 'form.new_constraint' do
      fill_in :constraint_description, with: constraint.description
      find('input#save-constraint', visible: false).trigger('click')
    end
    expect(Constraint.count).to eq 1
  end
end
