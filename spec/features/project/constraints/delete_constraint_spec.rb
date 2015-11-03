require 'spec_helper'

feature 'Delete a constraint' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }
  let!(:constraint) { create :constraint, user_story: user_story }

  background do
    sign_in user
    visit project_user_stories_path project
    find('.user-story').click
  end

  scenario 'should show me a delete link', js: true do
    within '.delete-constraint-edit' do
      expect(page).to have_selector 'a#delete_constraint'
    end
  end

  scenario 'should delete a constraint successfully', js: true do
    within '.delete-constraint-edit' do
      find('a#delete_constraint').trigger('click')
    end

    expect{ Constraint.exists? constraint.id }.to become_eq false
  end

  scenario 'should remove the constraint from the form', js: true do
    within '.delete-constraint-edit' do
      find('a#delete_constraint').trigger('click')
    end

    expect(page).not_to have_selector('.delete-constraint-edit')
  end
end
