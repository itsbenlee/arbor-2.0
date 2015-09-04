require 'spec_helper'

feature 'Edit an user story' do
  let!(:user)        { create :user }
  let!(:project)     { create :project, owner: user }
  let!(:hypothesis)  { create :hypothesis, project: project }
  let!(:user_story)  do
    create :user_story, project: project, hypothesis: hypothesis
  end
  let(:changed_user_story) do
    build(
      :user_story,
      project:    project,
      hypothesis: hypothesis,
      role:       'Admin',
      action:     'administrate',
      result:     'do my work'
    )
  end

  background do
    sign_in user
  end

  scenario 'should show me the user story edit form after following the edit
    link on lab section' do
    visit project_hypotheses_path project
    %w(user_story_role user_story_action user_story_result).each do |input|
      expect(page).to have_field input
    end
  end

  scenario 'should be able to edit an user_story on lab section' do
    visit project_hypotheses_path project
    within 'form.edit_user_story' do
      fill_in 'user_story_role', with: changed_user_story.role
      fill_in 'user_story_action', with: changed_user_story.action
      fill_in 'user_story_result', with: changed_user_story.result
      click_button 'Save'
    end

    visit project_hypotheses_path project

    %i(role action result).each do |field|
      within 'form.edit_user_story' do
        field_id = "#user_story_#{field}"
        field_value = page.find(field_id).value
        expect(field_value).to have_text changed_user_story.send(field)
        expect(field_value).not_to have_content user_story.send(field)
      end
    end
  end

  scenario 'should show me the user story edit form after following the edit
    link on backlog section' do
    visit project_user_stories_path project
    %w(user_story_role user_story_action user_story_result).each do |input|
      expect(page).to have_field input
    end
  end

  scenario 'should be able to edit an user story on the backlog section',
    js: true do
    visit project_user_stories_path project
    find('.user-story').click

    within 'form.edit_user_story' do
      fill_in 'user_story_role', with: changed_user_story.role
      fill_in 'user_story_action', with: changed_user_story.action
      fill_in 'user_story_result', with: changed_user_story.result
      find('.user-story-submit', visible: false).trigger('click')
    end

    visit project_hypotheses_path project

    %i(role action result).each do |field|
      within 'form.edit_user_story' do
        field_id = "#user_story_#{field}"
        field_value = page.find(field_id).value
        expect(field_value).to have_text changed_user_story.try(field)
        expect(field_value).not_to have_content user_story.try(field)
      end
    end
  end
end
