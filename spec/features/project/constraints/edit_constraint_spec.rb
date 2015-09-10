require 'spec_helper'

feature 'Update a constraint' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }
  let!(:constraint) { create :constraint, user_story: user_story }

  background do
    sign_in user
    visit project_user_stories_path project
    find('.user-story').click
  end

  scenario 'should show me a constraint edit form', js: true do
    expect(page).to have_css 'form.edit_constraint'
    within 'form.edit_constraint' do
      expect(page).to have_field :constraint_description
    end
  end

  scenario 'should update a constraint', js: true do
    pending 'Need to fix javascript/database cleaner/shared connection'

    within 'form.edit_constraint' do
      fill_in :constraint_description, with: 'new description'
      find('input#save-constraint', visible: false).trigger('click')
    end
    expect(Constraint.first.description).to eq 'new description'
  end
end
