require 'spec_helper'

feature 'Create a new constraint' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }
  let(:constraint)  { build :constraint, description: 'My description' }

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

  def new_constraint
    within 'form.new_constraint' do
      fill_in(
        :constraint_description,
        with: 'constraint.description'
      )
      find('input#save-constraint', visible: false).trigger('click')
    end
  end

  scenario 'should show an error with duplicate constraints', js: true do
    new_constraint
    new_constraint
    expect(page).to have_content('Description has already been taken')
  end

  scenario 'should show an error with blank constraints', js: true do
    fill_in(
      :constraint_description,
      with: '    '
    )
    find('input#save-constraint', visible: false).trigger('click')
    expect(page).to have_content("Description can't be blank")
  end
end
