require 'spec_helper'

feature 'Edit an epic' do
  let!(:user)        { create :user }
  let!(:project)     { create :project, owner: user }
  let!(:hypothesis)  { create :hypothesis, project: project }
  let!(:epic)        { create :epic, project: project, hypothesis: hypothesis }
  let(:changed_epic) do
    build(
      :epic,
      project:    project,
      hypothesis: hypothesis,
      role:       'Admin',
      action:     'administrate',
      result:     'do my work'
    )
  end

  before :each do
    sign_in user
    visit project_hypotheses_path project
  end

  scenario 'should show me the epic edit form after following the edit link' do
    click_link 'Edit'

    %w(Role Action Result).each do |input|
      expect(page).to have_field input
    end
  end

  scenario 'should be able to edit an epic' do
    click_link 'Edit'

    fill_in 'Role', with: changed_epic.role
    fill_in 'Action', with: changed_epic.action
    fill_in 'Result', with: changed_epic.result

    click_button 'Save'

    %i(role action result).each do |field|
      expect(page).to have_content changed_epic.send(field)
      expect(page).not_to have_content epic.send(field)
    end
  end
end
